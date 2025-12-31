//
//  HomeViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation
import CoreLocation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var weatherText: String = "Today · —°C · — · —"
    @Published var weatherSymbol: String = "sun.max"
    @Published var isWeatherLoading: Bool = true
    @Published var isTipLoading: Bool = true
    @Published var styleTipTitle: String = "Style Tip"
    @Published var styleTipText: String = "Balance proportions by pairing relaxed fits with structured pieces."
    @Published var calendarItems: [OutfitCalendarSectionView.DayItem] = []

    @Published var isTodayPickLoading: Bool = true
    @Published var todayPickTitle: String = "Urban Minimalist"
    @Published var todayPickDescription: String = "Styled from your wardrobe for today’s weather."
    @Published var todayPickImageURL: String? = nil

    private let locationService: LocationService
    private let weatherService: WeatherServicing
    private let tipService: TipServicing
    private let todayPickService: TodayPickServicing

    private var didLoadOnce = false

    private let dayKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private let monthDayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d"
        return f
    }()

    private let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "EEE"
        return f
    }()

    init(
        locationService: LocationService = LocationService(),
        weatherService: WeatherServicing = WeatherService(),
        tipService: TipServicing = TipService(),
        todayPickService: TodayPickServicing = TodayPickService()
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
        self.tipService = tipService
        self.todayPickService = todayPickService
    }

    func loadIfNeeded() {
        guard didLoadOnce == false else { return }
        didLoadOnce = true
        loadCalendarPreview()
        load()
        isTipLoading = true
        Task { await fetchDailyTip() }
        Task { await fetchDefaultSuggestions() }
    }

    func load() {
        isWeatherLoading = true
        locationService.requestLocation { [weak self] coord in
            Task { await self?.fetchWeather(coord: coord) }
        } onError: { [weak self] _ in
            self?.weatherText = "Enable location to see weather"
            self?.isWeatherLoading = false
        }
    }

    func loadCalendarPreview() {
        let today = Date()
        let cal = Calendar.current
        let dates: [Date] = (0..<8).compactMap { cal.date(byAdding: .day, value: $0, to: today) }

        let symbol = weatherSymbol
        let temp = extractTempText(from: weatherText)

        calendarItems = dates.enumerated().map { idx, d in
            let key = dayKey(for: d)
            let title: String
            if idx == 0 { title = "Today" }
            else if idx == 1 { title = "Tomorrow" }
            else { title = weekdayTitle(for: d) }

            let subtitle = monthDayTitle(for: d)

            if let stored = UserDefaults.standard.string(forKey: "outfit.canvas.\(key)") {
                let resolvedPath = resolveCanvasPath(from: stored)

                return OutfitCalendarSectionView.DayItem(
                    id: key,
                    title: title,
                    subtitle: subtitle,
                    weatherSymbol: symbol,
                    tempText: temp,
                    state: OutfitCalendarSectionView.DayItem.State.planned(imagePath: resolvedPath)
                )
            } else {
                return OutfitCalendarSectionView.DayItem(
                    id: key,
                    title: title,
                    subtitle: subtitle,
                    weatherSymbol: symbol,
                    tempText: temp,
                    state: OutfitCalendarSectionView.DayItem.State.empty
                )
            }
        }
    }

    private func fetchWeather(coord: CLLocationCoordinate2D) async {
        defer { isWeatherLoading = false }

        do {
            let dto = try await weatherService.fetchCurrent(lat: coord.latitude, lon: coord.longitude)

            let current = dto.currentWeather
            guard current.temperature.isFinite else {
                weatherText = "Weather unavailable"
                weatherSymbol = "questionmark.circle"
                loadCalendarPreview()
                return
            }

            let temp = Int(current.temperature.rounded())
            let condition = WeatherCode.description(for: current.weathercode)

            weatherText = "Today · \(temp)°C · Light wind"
            weatherSymbol = HomeViewConstants.weatherSymbolName(for: current.weathercode)
            loadCalendarPreview()
        } catch {
            weatherText = "Weather unavailable"
            weatherSymbol = "questionmark.circle"
            loadCalendarPreview()
        }
    }

    private func resolveCanvasPath(from stored: String) -> String {
        if stored.contains("/") {
            return stored
        }

        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("outfits", isDirectory: true)
        return dir.appendingPathComponent(stored).path
    }

    private func dayKey(for date: Date) -> String {
        dayKeyFormatter.string(from: date)
    }

    private func monthDayTitle(for date: Date) -> String {
        monthDayFormatter.string(from: date)
    }

    private func weekdayTitle(for date: Date) -> String {
        weekdayFormatter.string(from: date)
    }

    private func extractTempText(from text: String) -> String {
        let digits = text.filter { $0.isNumber || $0 == "-" }
        if digits.isEmpty { return "—" }
        return "\(digits)°"
    }

    private func fetchDefaultSuggestions() async {
        isTodayPickLoading = true
        defer { isTodayPickLoading = false }

        do {
            let suggestions = try await withTimeout(seconds: 6) {
                try await self.todayPickService.fetchDefaultSuggestions()
            }

            guard let first = suggestions.first else { return }

            todayPickTitle = first.title
            todayPickDescription = first.description
            todayPickImageURL = first.imageURL
        } catch {}
    }

    private func fetchDailyTip() async {
        isTipLoading = true
        defer { isTipLoading = false }

        do {
            let dto = try await withTimeout(seconds: 6) {
                try await self.tipService.fetchDailyTip()
            }

            styleTipText = dto.tip
            styleTipTitle = "Style Tip"
        } catch {}
    }

    private func withTimeout<T>(seconds: Double, operation: @escaping () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            group.addTask {
                let ns = UInt64(seconds * 1_000_000_000)
                try await Task.sleep(nanoseconds: ns)
                throw URLError(.timedOut)
            }

            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }
}

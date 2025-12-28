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

    private let locationService: LocationService
    private let weatherService: WeatherServicing

    init(
        locationService: LocationService = LocationService(),
        weatherService: WeatherServicing = WeatherService()
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
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

    private func fetchWeather(coord: CLLocationCoordinate2D) async {
        defer { isWeatherLoading = false }

        do {
            let dto = try await weatherService.fetchCurrent(lat: coord.latitude, lon: coord.longitude)

            let current = dto.currentWeather
            guard current.temperature.isFinite else {
                weatherText = "Weather unavailable"
                weatherSymbol = "questionmark.circle"
                return
            }

            let temp = Int(current.temperature.rounded())
            let condition = WeatherCode.description(for: current.weathercode)

            weatherText = "Today · \(temp)°C · Light wind"
            weatherSymbol = HomeViewConstants.weatherSymbolName(for: current.weathercode)
        } catch {
            weatherText = "Weather unavailable"
            weatherSymbol = "questionmark.circle"
        }
    }
}

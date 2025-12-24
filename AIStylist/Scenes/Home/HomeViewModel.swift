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

    private let locationService: LocationService
    private let weatherService: WeatherServicing

    init(
        locationService: LocationService = LocationService(),
        weatherService: WeatherServicing = WeatherService(client: URLSessionHTTPClient())
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
    }

    func load() {
        locationService.requestLocation { [weak self] coord in
            Task { await self?.fetchWeather(coord: coord) }
        } onError: { [weak self] _ in
            self?.weatherText = "Enable location to see weather"
        }
    }

    private func fetchWeather(coord: CLLocationCoordinate2D) async {
        do {
            let dto = try await weatherService.fetchCurrent(lat: coord.latitude, lon: coord.longitude)

            let temp = Int(dto.currentWeather.temperature.rounded())
            let condition = WeatherCode.description(for: dto.currentWeather.weathercode)

            weatherText = "Today · \(temp)°C · \(condition) · Light wind"
        } catch {
            weatherText = "Weather unavailable"
        }
    }
}

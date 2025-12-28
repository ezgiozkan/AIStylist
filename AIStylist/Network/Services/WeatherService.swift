//
//  WeatherService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

protocol WeatherServicing {
    func fetchCurrent(lat: Double, lon: Double) async throws -> WeatherDTO
}

final class WeatherService: WeatherServicing {
    func fetchCurrent(lat: Double, lon: Double) async throws -> WeatherDTO {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            .init(name: "latitude", value: String(lat)),
            .init(name: "longitude", value: String(lon)),
            .init(name: "current", value: "temperature_2m,wind_speed_10m,weather_code"),
            .init(name: "timezone", value: "auto")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(WeatherDTO.self, from: data)
    }
}

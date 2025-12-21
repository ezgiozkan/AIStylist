//
//  WeatherServiceManager.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

struct WeatherDTO: Decodable {
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
    }

    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let weathercode: Int
    }
}

protocol WeatherServicing {
    func fetchCurrent(lat: Double, lon: Double) async throws -> WeatherDTO
}

final class WeatherService: WeatherServicing {
    private let client: ApiClient
    private let baseURL = URL(string: "https://api.open-meteo.com")!

    init(client: ApiClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func fetchCurrent(lat: Double, lon: Double) async throws -> WeatherDTO {
        let endpoint = Endpoint(
            baseURL: baseURL,
            path: "/v1/forecast",
            method: .get,
            query: [
                .init(name: "latitude", value: "\(lat)"),
                .init(name: "longitude", value: "\(lon)"),
                .init(name: "current_weather", value: "true")
            ]
        )
        return try await client.send(endpoint, as: WeatherDTO.self)
    }
}

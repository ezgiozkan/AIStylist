//
//  WeatherModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation

struct WeatherDTO: Decodable {

    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let weathercode: Int
    }

    private struct Current: Decodable {
        let temperature: Double
        let windspeed: Double
        let weathercode: Int

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case windSpeed10m = "wind_speed_10m"
            case weatherCode = "weather_code"
            case temperature = "temperature"
            case windspeed = "windspeed"
            case weathercode = "weathercode"
        }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)

            temperature = (try? c.decode(Double.self, forKey: .temperature2m))
                ?? (try? c.decode(Double.self, forKey: .temperature))
                ?? .nan

            windspeed = (try? c.decode(Double.self, forKey: .windSpeed10m))
                ?? (try? c.decode(Double.self, forKey: .windspeed))
                ?? .nan

            weathercode = (try? c.decode(Int.self, forKey: .weatherCode))
                ?? (try? c.decode(Int.self, forKey: .weathercode))
                ?? -1
        }
    }

    private enum CodingKeys: String, CodingKey {
        case current
        case currentWeatherLegacy = "current_weather"
    }

    private let current: Current?
    private let currentWeatherLegacy: CurrentWeather?

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        current = try? c.decode(Current.self, forKey: .current)
        currentWeatherLegacy = try? c.decode(CurrentWeather.self, forKey: .currentWeatherLegacy)
    }

    var currentWeather: CurrentWeather {
        if let current {
            return .init(
                temperature: current.temperature,
                windspeed: current.windspeed,
                weathercode: current.weathercode
            )
        }
        if let legacy = currentWeatherLegacy {
            return legacy
        }
        return .init(temperature: .nan, windspeed: .nan, weathercode: -1)
    }
}

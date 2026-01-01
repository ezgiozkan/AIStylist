//
//  WardropeService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

final class WardropeService {
    func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(http.statusCode) else {
            throw NSError(
                domain: "WardropeService",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Request failed (\(http.statusCode))"]
            )
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

protocol WardrobeServicing {
    func fetchWardrobeItem(id: String, accessToken: String?) async throws -> WardrobeItemResponse
}

struct WardrobeService: WardrobeServicing {

    private enum Constants {
        static let baseURLString = "https://ai-stylist-production.up.railway.app"
        static let wardrobePath = "wardrobe"
    }

    func fetchWardrobeItem(id: String, accessToken: String?) async throws -> WardrobeItemResponse {
        let baseURL = URL(string: Constants.baseURLString)!
        let url = baseURL
            .appendingPathComponent(Constants.wardrobePath)
            .appendingPathComponent(id)

        print("➡️ Wardrobe GET REQUEST")
        print("URL:", url.absoluteString)
        print("Token empty:", (accessToken?.isEmpty ?? true))

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("⬅️ Wardrobe GET HTTP Status:", http.statusCode)
        }
        print("⬅️ Wardrobe GET raw response:")
        print(String(data: data, encoding: .utf8) ?? "nil")

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw WardrobeHTTPError(statusCode: http.statusCode, data: data)
        }

        return try JSONDecoder().decode(WardrobeItemResponse.self, from: data)
    }
}

struct WardrobeHTTPError: LocalizedError {
    let statusCode: Int
    let data: Data

    var errorDescription: String? {
        let raw = String(data: data, encoding: .utf8) ?? ""
        if raw.isEmpty {
            return "Wardrobe request failed with HTTP \(statusCode)"
        }
        return "Wardrobe request failed with HTTP \(statusCode): \(raw)"
    }
}

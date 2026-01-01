//
//  RecommendOutfitService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

protocol RecommendOutfitServicing {
    func recommendOutfit(token: String, weather: String, occasion: String) async throws -> RecommendOutfitResponse
}

struct RecommendOutfitService: RecommendOutfitServicing {
    private enum Constants {
        static let baseURLString = "https://ai-stylist-production.up.railway.app"
        static let path = "recommend-outfit"
    }

    func recommendOutfit(token: String, weather: String, occasion: String) async throws -> RecommendOutfitResponse {
        let baseURL = URL(string: Constants.baseURLString)!
        let url = baseURL.appendingPathComponent(Constants.path)

        print("➡️ RecommendOutfit REQUEST")
        print("URL:", url.absoluteString)
        print("Weather:", weather)
        print("Occasion:", occasion)
        print("Token empty:", token.isEmpty)

        let body = RecommendOutfitRequest(weather: weather, occasion: occasion)
        let request = try URLRequest.aiStylistPOST(url: url, body: body, bearerToken: token)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("⬅️ HTTP Status:", http.statusCode)
        }

        print("⬅️ Raw response:")
        print(String(data: data, encoding: .utf8) ?? "nil")

        do {
            let decoded = try JSONDecoder().decode(RecommendOutfitResponse.self, from: data)
            print("✅ Decode SUCCESS")
            return decoded
        } catch {
            print("❌ Decode FAILED")
            print(error)
            throw error
        }
    }
}

extension URLRequest {
    static func aiStylistPOST<T: Encodable>(url: URL, body: T, bearerToken: String) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !bearerToken.isEmpty {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}

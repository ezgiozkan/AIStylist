//
//  TodayPickService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

protocol TodayPickServicing {
    func fetchDefaultSuggestions() async throws -> [DefaultSuggestionModel]
}

struct TodayPickService: TodayPickServicing {
    private enum Constants {
        static let baseURLString = "https://ai-stylist-production.up.railway.app"
        static let path = "default-suggestions"
    }

    func fetchDefaultSuggestions() async throws -> [DefaultSuggestionModel] {
        let baseURL = URL(string: Constants.baseURLString)!
        let url = baseURL.appendingPathComponent(Constants.path)

        let request = URLRequest.aiStylistGET(url: url)
        let data = try await URLSession.shared.aiStylistData(for: request)
        return try JSONDecoder().decode([DefaultSuggestionModel].self, from: data)
    }
}

extension URLRequest {
    static func aiStylistGET(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

extension URLSession {
    func aiStylistData(for request: URLRequest) async throws -> Data {
        let (data, response) = try await data(for: request)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

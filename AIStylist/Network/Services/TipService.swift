//
//  TipService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import UIKit

protocol TipServicing {
    func fetchDailyTip() async throws -> DailyTipModel
}

struct TipService: TipServicing {
    func fetchDailyTip() async throws -> DailyTipModel {
        let baseURL = URL(string: "https://ai-stylist-production.up.railway.app")!
        let url = baseURL.appendingPathComponent("daily-tip")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(DailyTipModel.self, from: data)
    }
}

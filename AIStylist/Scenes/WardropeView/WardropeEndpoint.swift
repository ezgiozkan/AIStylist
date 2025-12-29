//
//  WardropeEndpoint.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

enum WardropeEndpoint {

    case wardrobe

    static var baseURL: String {
        "https://ai-stylist-production.up.railway.app"
    }

    var path: String {
        switch self {
        case .wardrobe:
            return "/wardrobe"
        }
    }

    var method: String {
        switch self {
        case .wardrobe:
            return "GET"
        }
    }

    func urlRequest(bearerToken: String) throws -> URLRequest {
        guard let url = URL(string: Self.baseURL + path) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

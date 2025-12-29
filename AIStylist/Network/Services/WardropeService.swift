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

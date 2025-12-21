//
//  RequestBuilder.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

enum RequestBuilder {
    static func build(_ endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                       resolvingAgainstBaseURL: false)
        if !endpoint.query.isEmpty { components?.queryItems = endpoint.query }
        guard let url = components?.url else { throw NetworkError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.httpBody = endpoint.body
        endpoint.headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.key) }
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }
}

//
//  Endpoint.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

enum HTTPMethod: String { case get = "GET", post = "POST", put = "PUT", delete = "DELETE" }

struct Endpoint {
    var baseURL: URL
    var path: String
    var method: HTTPMethod
    var query: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data? = nil
}

//
//  ClothingUploadEndpoint.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import Foundation

enum ClothingUploadEndpoint {
    static let baseURL = URL(string: "https://ai-stylist-production.up.railway.app")!

    static func upload(authToken: String?) -> Endpoint {
        var headers: [String: String] = [
            "accept": "application/json"
        ]

        if let authToken, !authToken.isEmpty {
            headers["Authorization"] = "Bearer \(authToken)"
        }

        return Endpoint(
            baseURL: baseURL,
            path: "/upload-clothing",
            method: .post,
            headers: headers
        )
    }

    static var upload: Endpoint {
        upload(authToken: nil)
    }
}

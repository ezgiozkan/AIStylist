//
//  ClothingUploadEndpoint.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import Foundation

enum ClothingUploadEndpoint {
    static let baseURL = URL(string: "https://ai-stylist-production.up.railway.app")!

    static var upload: Endpoint {
        Endpoint(
            baseURL: baseURL,
            path: "/upload-clothing",
            method: .post,
            headers: ["accept": "application/json"]
        )
    }
}

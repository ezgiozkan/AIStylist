//
//  Environment.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

enum Environment {
    case prod
    case test

    var baseURL: URL {
        switch self {
        case .prod: return URL(string: "https://api.yourbackend.com")!
        case .test: return URL(string: "https://api-test.yourbackend.com")!
        }
    }
}

//
//  NetworkError.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case http(status: Int, data: Data)
    case decoding(Error)
}

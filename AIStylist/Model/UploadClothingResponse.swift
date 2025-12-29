//
//  UploadClothingResponse.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import Foundation

struct UploadClothingResponse: Decodable {
    let id: String?
    let status: String?
    let imageUrl: String?
    let analysis: Analysis?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case imageUrl
        case analysis
    }

    struct Analysis: Decodable {
        let category: String?
        let color: String?
        let season: String?
        let formality: String?
        let description: String?
        let imageUrl: String?

        enum CodingKeys: String, CodingKey {
            case category
            case color
            case season
            case formality
            case description
            case imageUrl
        }
    }
}

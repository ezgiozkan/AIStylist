//
//  RecommendOutfitResponse.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

struct RecommendOutfitRequest: Encodable {
    let weather: String
    let occasion: String
}

struct RecommendOutfitResponse: Decodable {
    struct SelectedItem: Decodable {
        let id: String
        let category: String
        let color: String
        let imageURL: String
        let season: String
        let formality: String
        let description: String

        enum CodingKeys: String, CodingKey {
            case id
            case category
            case color
            case imageURL = "image_url"
            case season
            case formality
            case description
        }
    }

    let outfitName: String
    let selectedItems: [SelectedItem]
    let reasoning: String

    enum CodingKeys: String, CodingKey {
        case outfitName = "outfit_name"
        case selectedItems = "selected_items"
        case reasoning
    }
}

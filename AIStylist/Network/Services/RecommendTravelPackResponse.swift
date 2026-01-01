//
//  RecommendTravelPackResponse.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

struct RecommendTravelPackResponseDTO: Decodable {
    let pack_name: String
    let items_to_pack: [RecommendTravelPackItemDTO]
    let outfit_combinations: [String]
    let reasoning: String
}

struct RecommendTravelPackItemDTO: Decodable {
    let id: String
    let category: String
    let color: String
    let image_url: String
    let season: String?
    let formality: String?
    let description: String?
    let status: String?
}

struct RecommendTravelPackRequest: Encodable {
    let destination: String
    let days: Int
    let weather: String
}

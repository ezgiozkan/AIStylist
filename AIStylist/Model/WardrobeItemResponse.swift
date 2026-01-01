//
//  WardrobeItemResponse.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 1.01.2026.
//

import Foundation

struct WardrobeItemResponse: Decodable {
    let id: String
    let category: String
    let color: String
    let imageURL: String
    let season: String
    let formality: String
    let description: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case color
        case imageURL = "image_url"
        case season
        case formality
        case description
        case status
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = (try? c.decode(String.self, forKey: .id)) ?? ""
        category = (try? c.decode(String.self, forKey: .category)) ?? ""
        color = (try? c.decode(String.self, forKey: .color)) ?? ""
        imageURL = (try? c.decode(String.self, forKey: .imageURL)) ?? ""
        season = (try? c.decode(String.self, forKey: .season)) ?? ""
        formality = (try? c.decode(String.self, forKey: .formality)) ?? ""
        description = (try? c.decode(String.self, forKey: .description)) ?? ""
        status = (try? c.decode(String.self, forKey: .status)) ?? "PROCESSING"
    }
}

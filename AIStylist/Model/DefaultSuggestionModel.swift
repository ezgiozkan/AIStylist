//
//  DefaultSuggestionModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

struct DefaultSuggestionModel: Decodable {
    let type: String
    let title: String
    let description: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case imageURL = "image_url"
    }
}

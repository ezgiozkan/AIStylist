//
//  WardrobeModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeItem: Identifiable, Decodable {
    let id: String
    let categoryRaw: String
    let color: String
    let imageUrl: String
    let season: String
    let formality: String
    let itemDescription: String

    var title: String {
        if !categoryRaw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return categoryRaw
        }
        return "Item"
    }

    var remoteURL: URL? {
        let trimmed = imageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        return URL(string: trimmed)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case categoryRaw = "category"
        case color
        case imageUrl = "image_url"
        case season
        case formality
        case itemDescription = "description"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = (try? c.decode(String.self, forKey: .id)) ?? UUID().uuidString
        categoryRaw = (try? c.decode(String.self, forKey: .categoryRaw)) ?? ""
        color = (try? c.decode(String.self, forKey: .color)) ?? ""
        imageUrl = (try? c.decode(String.self, forKey: .imageUrl)) ?? ""
        season = (try? c.decode(String.self, forKey: .season)) ?? ""
        formality = (try? c.decode(String.self, forKey: .formality)) ?? ""
        itemDescription = (try? c.decode(String.self, forKey: .itemDescription)) ?? ""
    }
}

extension WardrobeItem {
    var imageSymbol: String { "photo" }
}

struct CanvasItem: Identifiable {
    let id: UUID
    var image: UIImage

    var offset: CGSize = .zero
    var scale: CGFloat = 1
    var rotation: Angle = .zero
    var zIndex: Double = 0
}

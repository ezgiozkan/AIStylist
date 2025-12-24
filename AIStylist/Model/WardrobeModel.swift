//
//  WardrobeModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import Foundation

struct WardrobeItem: Identifiable {
    let id: UUID
    let title: String
    let category: WardrobeCategory
    var isFavorite: Bool
    let imageName: String

    static let demo: [WardrobeItem] = [
        .init(id: UUID(), title: "Classic Trench", category: .outerwear, isFavorite: false, imageName: "tshirt"),
        .init(id: UUID(), title: "Slim Fit Jeans", category: .bottoms, isFavorite: true, imageName: "jeans"),
        .init(id: UUID(), title: "White Linen Shirt", category: .tops, isFavorite: false, imageName: "shirt"),
        .init(id: UUID(), title: "Leather Boots", category: .shoes, isFavorite: true, imageName: "boot"),
        .init(id: UUID(), title: "Silk Scarf", category: .tops, isFavorite: false, imageName: "scarf"),
        .init(id: UUID(), title: "Basic Tee", category: .tops, isFavorite: false, imageName: "tshirt"),
    ]
}

extension WardrobeItem {
   var imageSymbol: String {
       switch imageName {
       case "jeans": return "figure.walk"
       case "shirt": return "shirt.fill"
       case "boot": return "boot"
       case "scarf": return "scissors"
       default: return "tshirt"
       }
   }
}

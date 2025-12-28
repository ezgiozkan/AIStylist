//
//  WardrobeModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeItem: Identifiable {
    let id: UUID
    let title: String
    let category: WardrobeCategory
    var isFavorite: Bool
    let imageName: String

    var image: UIImage {
        UIImage(named: imageName) ?? UIImage()
    }

    init(
        id: UUID = UUID(),
        title: String,
        category: WardrobeCategory,
        isFavorite: Bool = false,
        imageName: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isFavorite = isFavorite
        self.imageName = imageName
    }
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

struct CanvasItem: Identifiable {
    let id: UUID
    let image: UIImage

    var offset: CGSize = .zero
    var scale: CGFloat = 1
    var rotation: Angle = .zero
    var zIndex: Double = 0
}

// MARK: - Demo Data

extension WardrobeItem {
    static let demo: [WardrobeItem] = [
        .init(title: "Classic Trench", category: .outerwear, imageName: "tshirt"),
        .init(title: "Slim Fit Jeans", category: .bottoms, isFavorite: true, imageName: "jeans"),
        .init(title: "White Linen Shirt", category: .tops, imageName: "shirt"),
        .init(title: "Leather Boots", category: .shoes, isFavorite: true, imageName: "boot"),
        .init(title: "Silk Scarf", category: .tops, imageName: "scarf"),
        .init(title: "Basic Tee", category: .tops, imageName: "tshirt")
    ]
}

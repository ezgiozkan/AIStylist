//
//  WardrobeCategory.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

enum WardrobeCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case tops = "Tops"
    case bottoms = "Bottoms"
    case dresses = "Dresses"
    case outerwear = "Outerwear"
    case shoes = "Shoes"
    
    var id: String { rawValue }
    var title: String { rawValue }
}

enum WardrobeLayout {
    static let gridSpacing: CGFloat = 16
    static let columns: [GridItem] = [
        GridItem(.flexible(), spacing: gridSpacing),
        GridItem(.flexible(), spacing: gridSpacing)
    ]

    static let cardCornerRadius: CGFloat = 18
    static let cardInnerCornerRadius: CGFloat = 16
    static let imageHeight: CGFloat = 150

    static let pillHeight: CGFloat = 36
    static let pillHorizontalPadding: CGFloat = 14
}

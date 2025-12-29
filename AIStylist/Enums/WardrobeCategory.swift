//
//  WardrobeCategory.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeCategoryTab: Identifiable, Hashable {
    let id: String
    let title: String

    static let all = WardrobeCategoryTab(id: "all", title: "All")
}

extension String {
    var wardrobeCategoryKey: String {
        trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    var wardrobeCategoryTitle: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
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

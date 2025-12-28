//
//  WardropeViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//


import SwiftUI

final class WardrobeViewModel: ObservableObject {

    @Published var selectedCategory: WardrobeCategory = .all
    @Published var items: [WardrobeItem] = WardrobeItem.demo
    @Published var showCreateOutfit: Bool = false

    var filteredItems: [WardrobeItem] {
        guard selectedCategory != .all else { return items }
        return items.filter { $0.category == selectedCategory }
    }

    func toggleFavorite(for id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isFavorite.toggle()
    }
}

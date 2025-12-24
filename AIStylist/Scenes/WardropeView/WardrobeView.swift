//
//  WardrobeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct WardrobeView: View {
    @State private var selectedCategory: WardrobeCategory = .all
    @State private var items: [WardrobeItem] = WardrobeItem.demo

    private var filteredItems: [WardrobeItem] {
        guard selectedCategory != .all else { return items }
        return items.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    WardrobeCategoryTabs(
                        selected: $selectedCategory,
                        categories: WardrobeCategory.allCases
                    )

                    if filteredItems.isEmpty {
                        EmptyStateView(
                            title: "No items yet",
                            subtitle: "Add your first clothing item to start building your wardrobe."
                        )
                        .padding(.top, 12)
                    } else {
                        LazyVGrid(
                            columns: WardrobeLayout.columns,
                            alignment: .center,
                            spacing: WardrobeLayout.gridSpacing
                        ) {
                            ForEach(filteredItems) { item in
                                WardrobeItemCard(
                                    item: item,
                                    onToggleFavorite: { toggleFavorite(for: item.id) }, onTap: nil
                                )
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))

            FloatingCreateButton {
                // TODO: navigate to Create
            }
            .padding(.trailing, 20)
            .padding(.bottom, 15)
        }
        .ignoresSafeArea(edges: .top)
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Wardrobe")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.primary)

            Spacer(minLength: 0)
        }
    }

    private func toggleFavorite(for id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isFavorite.toggle()
    }
}

#Preview {
    WardrobeView()
}

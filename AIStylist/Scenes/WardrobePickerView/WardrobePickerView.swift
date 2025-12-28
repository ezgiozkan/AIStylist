//
//  WardrobePickerView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//


import SwiftUI

struct WardrobePickerView: View {
    @State private var selectedCategory: WardrobeCategory = .all
    @State private var items: [WardrobeItem] = WardrobeItem.demo
    @State private var selectedIDs: Set<UUID> = []
    @State private var isCanvasPresented = false

    private var filteredItems: [WardrobeItem] {
        guard selectedCategory != .all else { return items }
        return items.filter { $0.category == selectedCategory }
    }

    private var selectedItems: [WardrobeItem] {
        items.filter { selectedIDs.contains($0.id) }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    WardrobeCategoryTabs(selected: $selectedCategory,
                                        categories: WardrobeCategory.allCases)

                    LazyVGrid(columns: WardrobeLayout.columns,
                              alignment: .center,
                              spacing: WardrobeLayout.gridSpacing) {
                        ForEach(filteredItems) { item in
                            WardrobeItemCard(
                                item: item,
                                isSelected: selectedIDs.contains(item.id),
                                isSelectionEnabled: true,
                                onToggleFavorite: nil,
                                onTap: { toggleSelection(for: item.id) }
                            )
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 0)
            }
        }
        .navigationTitle("Select items")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Text("\(selectedIDs.count)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.buttonPrimary)

                Button("Next") {
                    isCanvasPresented = true
                }
                .disabled(selectedIDs.isEmpty)
            }
        }
        .fullScreenCover(isPresented: $isCanvasPresented) {
            OutfitCanvasView(items: selectedItems)
        }
    }

    private func toggleSelection(for id: UUID) {
        if selectedIDs.contains(id) { selectedIDs.remove(id) }
        else { selectedIDs.insert(id) }
    }
}

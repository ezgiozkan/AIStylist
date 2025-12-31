//
//  WardrobePickerView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//


import SwiftUI

struct WardrobePickerView: View {
    let planDayKey: String

    @StateObject private var viewModel = WardrobePickerViewModel()
    @State private var isCanvasPresented = false
    @State private var didFetchWardrobe = false
    @SwiftUI.Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    WardrobeCategoryTabs(
                        selectedId: $viewModel.selectedCategoryId,
                        categories: viewModel.availableCategories
                    )

                    if viewModel.isLoading {
                        WardrobePickerSkeletonGrid()
                            .padding(.top, 4)
                    } else if let msg = viewModel.errorMessage {
                        EmptyStateView(
                            title: "Couldn’t load wardrobe",
                            subtitle: msg
                        )
                        .padding(.top, 12)
                    } else if viewModel.filteredItems.isEmpty {
                        EmptyStateView(
                            title: "No items yet",
                            subtitle: "Add your first clothing item to start building your wardrobe."
                        )
                        .padding(.top, 12)
                    } else {
                        LazyVGrid(columns: WardrobeLayout.columns,
                                  alignment: .center,
                                  spacing: WardrobeLayout.gridSpacing) {
                            ForEach(viewModel.filteredItems) { item in
                                WardrobeItemCard(
                                    item: item,
                                    isSelected: viewModel.selectedIDs.contains(item.id),
                                    isSelectionEnabled: true,
                                    onToggleFavorite: nil,
                                    onTap: { viewModel.toggleSelection(for: item.id) }
                                )
                            }
                        }
                        .padding(.top, 4)
                    }
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
                Text("\(viewModel.selectedIDs.count)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.buttonPrimary)

                Button("Next") {
                    isCanvasPresented = true
                }
                .disabled(viewModel.selectedIDs.isEmpty)
            }
        }
        .fullScreenCover(isPresented: $isCanvasPresented) {
            OutfitCanvasView(items: viewModel.selectedItems, dayKey: planDayKey)
        }
        .onReceive(NotificationCenter.default.publisher(for: .outfitCanvasDidSave)) { _ in
            dismiss()
        }
        .task {
            guard didFetchWardrobe == false else { return }
            didFetchWardrobe = true
            await viewModel.fetchWardrobe()
        }
    }
}

private struct WardrobePickerSkeletonGrid: View {
    var body: some View {
        LazyVGrid(
            columns: WardrobeLayout.columns,
            alignment: .center,
            spacing: WardrobeLayout.gridSpacing
        ) {
            ForEach(0..<8, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.black.opacity(0.06))
                    .frame(height: 180)
            }
        }
    }
}

//
//  WardrobeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct WardrobeView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @State private var showCreateOutfit = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {

                NavigationLink(
                    destination: CreateOutfitView().hideTabBarOnPush(),
                    isActive: $showCreateOutfit,
                    label: { EmptyView() }
                )
                .hidden()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        header

                        WardrobeCategoryTabs(
                            selectedId: $viewModel.selectedCategoryId,
                            categories: viewModel.availableCategories
                        )

                        if viewModel.isLoading {
                            WardrobeSkeletonGrid()
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
                            LazyVGrid(
                                columns: WardrobeLayout.columns,
                                alignment: .center,
                                spacing: WardrobeLayout.gridSpacing
                            ) {
                                ForEach(viewModel.filteredItems) { item in
                                    WardrobeItemCard(
                                        item: item,
                                        onToggleFavorite: { viewModel.toggleFavorite(for: item.id) },
                                        onTap: nil
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
                    showCreateOutfit = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 15)
            }
        }
        .onAppear {
            Task { await viewModel.fetchWardrobe() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Wardrobe")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.primary)

            Spacer(minLength: 0)
        }
    }

    private struct WardrobeSkeletonGrid: View {
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

}

#Preview {
    WardrobeView()
}

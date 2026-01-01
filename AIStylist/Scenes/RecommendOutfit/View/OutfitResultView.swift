//
//  OutfitResultView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import SwiftUI

struct OutfitResultView: View {
    private enum Layout {
        static let pagePadding: CGFloat = 20
        static let cardCornerRadius: CGFloat = 24
        static let gridCornerRadius: CGFloat = 14
        static let gridSpacing: CGFloat = 10
        static let itemImageSize: CGFloat = 46
    }

    let response: RecommendOutfitResponse
    let onClose: () -> Void

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(response.outfitName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)

                        HStack(spacing: 8) {
                            if let first = response.selectedItems.first {
                                chip(text: first.season)
                                chip(text: first.formality)
                            }
                        }

                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: Layout.gridSpacing), GridItem(.flexible(), spacing: Layout.gridSpacing)],
                            spacing: Layout.gridSpacing
                        ) {
                            ForEach(Array(response.selectedItems.prefix(4)), id: \.id) { item in
                                AsyncImage(url: URL(string: item.imageURL)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                    default:
                                        Color.black.opacity(0.06)
                                    }
                                }
                                .frame(height: 120)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: Layout.gridCornerRadius, style: .continuous))
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)

                    Text("SELECTED ITEMS")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.top, 2)

                    VStack(spacing: 0) {
                        ForEach(response.selectedItems, id: \.id) { item in
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: item.imageURL)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                    default:
                                        Color.black.opacity(0.06)
                                    }
                                }
                                .frame(width: Layout.itemImageSize, height: Layout.itemImageSize)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.category)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)

                                    Text(item.description)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Circle()
                                    .fill(Color.black.opacity(0.18))
                                    .frame(width: 10, height: 10)

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)

                            Divider().opacity(0.6)
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)

                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.buttonPrimary)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("AI Insight")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.primary)

                            Text(response.reasoning)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineSpacing(3)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
                }
                .padding(Layout.pagePadding)
            }
            .background(RecommendOutfitView.Colors.screenBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onClose) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.buttonPrimary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Your Outfit")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    private func chip(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color.buttonPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.buttonPrimary.opacity(0.10))
            )
    }
}

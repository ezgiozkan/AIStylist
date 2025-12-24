//
//  WardrobeItemCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeItemCard: View {
    let item: WardrobeItem
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: WardrobeLayout.cardInnerCornerRadius, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        Image(systemName: item.imageSymbol)
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.secondary)
                    )
                    .frame(height: WardrobeLayout.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: WardrobeLayout.cardInnerCornerRadius, style: .continuous))

                Button {
                    onToggleFavorite()
                } label: {
                    ZStack {
                        Circle().fill(Color.black.opacity(0.25))

                        Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(item.category.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.buttonPrimary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 2)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: WardrobeLayout.cardCornerRadius, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: WardrobeLayout.cardCornerRadius, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

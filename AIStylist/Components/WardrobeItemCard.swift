//
//  WardrobeItemCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeItemCard: View {
    let item: WardrobeItem

    var isSelected: Bool = false
    var isSelectionEnabled: Bool = false

    let onToggleFavorite: (() -> Void)?
    let onTap: (() -> Void)?
    
    private var placeholder: some View {
        RoundedRectangle(cornerRadius: WardrobeLayout.cardInnerCornerRadius, style: .continuous)
            .fill(Color(.secondarySystemBackground))
            .overlay(
                Image(systemName: item.imageSymbol)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.secondary)
            )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                Group {
                    if let url = item.remoteURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                placeholder
                            default:
                                placeholder
                            }
                        }
                    } else {
                        placeholder
                    }
                }
                .frame(height: WardrobeLayout.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: WardrobeLayout.cardInnerCornerRadius, style: .continuous))

                if isSelectionEnabled {
                    ZStack {
                        Circle()
                            .fill(isSelected ? Color.buttonPrimary : Color.black.opacity(0.10))

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(isSelected ? Color.white : Color.clear)
                    }
                    .frame(width: 28, height: 28)
                    .padding(10)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.categoryRaw)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(item.season)
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
                .stroke(isSelectionEnabled && isSelected ? Color.buttonPrimary : Color.black.opacity(0.06),
                        lineWidth: isSelectionEnabled && isSelected ? 2 : 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: WardrobeLayout.cardCornerRadius, style: .continuous))
        .onTapGesture { onTap?() }
    }
}

//
//  OccasionCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import SwiftUI

struct OccasionCard: View {
    let item: OccasionItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {

                RoundedRectangle(cornerRadius: RecommendOutfitView.Layout.cardCornerRadius, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: RecommendOutfitView.Layout.cardCornerRadius, style: .continuous)
                            .stroke(isSelected ? RecommendOutfitView.Colors.purple : Color.clear, lineWidth: 1.5)
                    )
                    .shadow(color: RecommendOutfitView.Colors.cardShadow, radius: 18, x: 0, y: 10)

                if isSelected {
                    ZStack {
                        Circle().fill(RecommendOutfitView.Colors.purple)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 22, height: 22)
                    .padding(12)
                }

                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(RecommendOutfitView.Colors.iconBackground)
                        Image(systemName: item.systemIconName)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(RecommendOutfitView.Colors.purple)
                    }
                    .frame(width: 54, height: 54)

                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? RecommendOutfitView.Colors.purple : RecommendOutfitView.Colors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 18)
            }
            .frame(height: RecommendOutfitView.Layout.cardHeight)
        }
        .buttonStyle(.plain)
    }
}

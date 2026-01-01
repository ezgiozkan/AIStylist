//
//  TravelCapsuleResultView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 1.01.2026.
//

import SwiftUI

struct TravelCapsuleResultView: View {

    private enum Layout {
        static let pagePadding: CGFloat = 20
        static let cornerRadius: CGFloat = 24
        static let smallCornerRadius: CGFloat = 18
        static let chipCornerRadius: CGFloat = 18
        static let itemImageSize: CGFloat = 46
    }

    let destination: String
    let days: Int
    let weatherTitle: String
    let response: RecommendTravelPackResponseDTO
    let onClose: () -> Void

    private var accent: Color { HomeViewConstants.buttonPrimaryColor }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    heroCard

                    packingListSection

                    outfitCombinationsSection

                    whyThisWorksSection
                }
                .padding(Layout.pagePadding)
            }
            .background(Color.black.opacity(0.03).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onClose) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(accent)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Travel Capsule")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    private var heroCard: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Travel Capsule")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)

                Text("Your smart packing list, built from your wardrobe.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    chip(icon: "mappin.and.ellipse", text: destination)
                    chip(icon: "calendar", text: "\(days) days")
                    chip(icon: "snowflake", text: weatherTitle)
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .fill(accent.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: "suitcase")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(accent)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
    }

    private var packingListSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PACKING LIST")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)

                Spacer()
            }

            VStack(spacing: 0) {
                ForEach(response.items_to_pack, id: \.id) { item in
                    packingRow(item)
                    if item.id != response.items_to_pack.last?.id {
                        Divider().opacity(0.6)
                    }
                }
            }
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
        }
    }

    private var outfitCombinationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OUTFIT COMBINATIONS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                ForEach(response.outfit_combinations.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(accent)

                        Text(response.outfit_combinations[index])
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.smallCornerRadius, style: .continuous))
                }
            }
        }
    }

    private var whyThisWorksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("AI STYLE INSIGHT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("AI ANALYSIS")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)

                Text(response.reasoning)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.95))
            }
            .padding(16)
            .background(accent)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous))
        }
    }

    private func packingRow(_ item: RecommendTravelPackItemDTO) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.image_url)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.black.opacity(0.06)
                }
            }
            .frame(width: Layout.itemImageSize, height: Layout.itemImageSize)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.category)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                Text(item.description ?? item.color)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: Layout.chipCornerRadius, style: .continuous)
                .fill(Color.black.opacity(0.05))
        )
    }
}

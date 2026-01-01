//
//  AnalyzeSuccessView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import SwiftUI

struct AnalyzeSuccessView: View {
    let wardrobeItem: WardrobeItemResponse
    var onViewWardrobe: (() -> Void)? = nil
    var onDone: (() -> Void)? = nil

    private var rawImageUrl: String {
        wardrobeItem.imageURL.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    HStack(alignment: .top) {
                        Spacer()

                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("SAVED")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.green.opacity(0.12))
                        .clipShape(Capsule())

                        Spacer()

                        Button {
                            onDone?()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 36, height: 36)
                                .background(.black.opacity(0.06))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 8)

                    Text("Saved to Wardrobe!")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)

                    Text("Item analyzed and added to your collection.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    card {
                        ZStack(alignment: .bottomTrailing) {
                            if let url = URL(string: rawImageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                    case .failure:
                                        placeholderImage
                                    default:
                                        ProgressView().frame(maxWidth: .infinity, minHeight: 240)
                                    }
                                }
                            } else {
                                placeholderImage
                            }

                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Analyzed")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.white.opacity(0.9))
                            .clipShape(Capsule())
                            .padding(12)
                        }
                    }

                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            chip(
                                title: "CATEGORY",
                                value: wardrobeItem.category,
                                icon: categoryIcon(wardrobeItem.category)
                            )
                            chip(
                                title: "COLOR",
                                value: wardrobeItem.color,
                                icon: colorIcon(wardrobeItem.color)
                            )
                        }
                        HStack(spacing: 12) {
                            chip(
                                title: "SEASON",
                                value: wardrobeItem.season,
                                icon: seasonIcon(wardrobeItem.season)
                            )
                            chip(
                                title: "FORMALITY",
                                value: wardrobeItem.formality,
                                icon: formalityIcon(wardrobeItem.formality)
                            )
                        }
                    }

                    card {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("AI Description")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            Text(wardrobeItem.description)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)
                        }
                    }

                    Spacer(minLength: 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            print("WARDROBE image_url 👉", wardrobeItem.imageURL)
            print("RAW (used) imageUrl 👉", rawImageUrl)
        }
    }

    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.black.opacity(0.06))
            .frame(maxWidth: .infinity, minHeight: 260)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
    }

    private func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 6)
    }

    private func chip(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 5)
    }

    private func categoryIcon(_ category: String?) -> String {
        switch category?.lowercased() {
        case "t-shirt", "tshirt", "shirt": return "tshirt"
        case "jacket", "coat": return "jacket"
        case "pants", "trousers", "jeans": return "pants"
        case "dress": return "figure.dress.line.vertical.figure"
        case "shoes", "sneakers": return "shoe"
        case "skirt": return "figure.skirt"
        default: return "tag"
        }
    }

    private func seasonIcon(_ season: String?) -> String {
        switch season?.lowercased() {
        case "summer": return "sun.max.fill"
        case "spring": return "leaf.fill"
        case "fall", "autumn": return "wind"
        case "winter": return "snowflake"
        case "spring/summer": return "sun.max"
        case "fall/winter": return "snowflake"
        default: return "calendar"
        }
    }

    private func formalityIcon(_ formality: String?) -> String {
        switch formality?.lowercased() {
        case "casual": return "tshirt"
        case "smart casual": return "person.crop.rectangle"
        case "formal": return "tie"
        case "business": return "briefcase.fill"
        default: return "person"
        }
    }

    private func colorIcon(_ color: String?) -> String {
        return "circle.fill"
    }
}

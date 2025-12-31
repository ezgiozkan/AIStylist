//
//  OutfitCalendarSectionView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI
import UIKit

struct OutfitCalendarSectionView: View {
    struct DayItem: Identifiable {
        enum State {
            case planned(imagePath: String)
            case empty
        }

        let id: String
        let title: String
        let subtitle: String
        let weatherSymbol: String
        let tempText: String
        let state: State
    }

    private enum Constants {
        static let cardRadius: CGFloat = 24
        static let tileRadius: CGFloat = 24
        static let tileSize = CGSize(width: 150, height: 150)
        static let headerHorizontalPadding: CGFloat = 20
        static let tilesHorizontalPadding: CGFloat = 20
        static let tilesSpacing: CGFloat = 16
        static let accent = Color.purple
    }

    let items: [DayItem]
    let onSeeAll: () -> Void
    let onTapDay: (DayItem) -> Void
    let onTapEmptyPlan: (DayItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Constants.tilesSpacing) {
                    ForEach(items) { item in
                        dayTile(item)
                    }
                }
                .padding(.horizontal, Constants.tilesHorizontalPadding)
                .padding(.vertical, 4)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Outfit Calendar")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)

            Spacer()

            Button(action: onSeeAll) {
                HStack(spacing: 6) {
                    Text("View Calendar")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.8))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Constants.headerHorizontalPadding)
    }

    private func dayTile(_ item: DayItem) -> some View {
        VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                Text(item.subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.gray.opacity(0.85))

                HStack(spacing: 6) {
                    Image(systemName: item.weatherSymbol)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.75))

                    Text(item.tempText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)

            ZStack {
                switch item.state {
                case .planned(let imagePath):
                    Group {
                        if let uiImage = UIImage(contentsOfFile: imagePath) {
                            let displayImage = uiImage.aiTrimmedAlpha() ?? uiImage
                            Image(uiImage: displayImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Constants.tileSize.width, height: Constants.tileSize.height)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous))
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous)
                                        .stroke(Color.black.opacity(0.12), lineWidth: 1)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous)
                                .fill(Color.black.opacity(0.06))
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous))
                    .onTapGesture { onTapDay(item) }

                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 6]))
                            .foregroundStyle(Color.gray.opacity(0.35))

                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Constants.accent.opacity(0.10))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Constants.accent)
                            }

                            Text("Plan")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Constants.accent)
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous))
                    .onTapGesture { onTapEmptyPlan(item) }
                }
            }
            .frame(width: Constants.tileSize.width, height: Constants.tileSize.height)
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 8)
        }
        .frame(width: Constants.tileSize.width)
    }
}

//
//  OutfitCalendarSectionView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct OutfitCalendarSectionView: View {
    struct DayItem: Identifiable {
        enum State {
            case planned(imageName: String)
            case empty
        }

        let id = UUID()
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
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(item.subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.gray.opacity(0.9))
                }

                Spacer()

                Image(systemName: item.weatherSymbol)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray.opacity(0.8))

                Text(item.tempText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
            }

            ZStack {
                RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous)
                    .fill(Color.white)

                switch item.state {
                case .planned(let imageName):
                    ZStack(alignment: .bottomTrailing) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Constants.tileSize.width, height: Constants.tileSize.height)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: Constants.tileRadius, style: .continuous))
                    }
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
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 10)
        }
        .frame(width: Constants.tileSize.width)
    }
}

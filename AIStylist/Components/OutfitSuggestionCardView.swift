//
//  OutfitSuggestionCardView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct OutfitSuggestionCardView: View {
    let style: Style
    let background: Color
    let subtitle: String

    enum Style {
        case casual
        case work

        var title: String {
            switch self {
            case .casual: return "CASUAL"
            case .work: return "WORK"
            }
        }

        var accent: Color {
            switch self {
            case .casual: return HomeViewConstants.casualTagText
            case .work: return HomeViewConstants.workTagText
            }
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(background)
            .overlay(
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(style.title)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(style.accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.7))
                            )

                        Spacer()

                        Image(systemName: "hanger")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(style.accent.opacity(0.6))
                    }

                    Text(subtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.black.opacity(0.55))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                }
                .padding(18),
                alignment: .topLeading
            )
            .frame(width: 300, height: 200)
            .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 10)
    }
}

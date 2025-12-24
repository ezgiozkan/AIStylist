//
//  OutfitSuggestionCardView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

enum OutfitCardType {
    case casual
    case work

    var tagTitle: String {
        switch self {
        case .casual: return "CASUAL"
        case .work: return "WORK"
        }
    }

    var imageName: String {
        switch self {
        case .casual: return "icon_casual"
        case .work: return "icon_work"
        }
    }

    var title: String {
        return "Daily Outfit Pick"
    }

    var tempDescription: String {
        switch self {
        case .casual:
            return "Effortless pieces chosen for comfort and everyday style."
        case .work:
            return "Clean, polished essentials curated for a confident workday."
        }
    }
}

struct OutfitSuggestionCardView: View {
    let type: OutfitCardType

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                Image(type.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 330)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))

                HStack {
                    Text(type.tagTitle)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.92))
                                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
                        )

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "hanger")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(type == .work ? Color.blue : Color.purple)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .overlay(Circle().stroke(Color.purple.opacity(0.18), lineWidth: 1))
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(type.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text(type.tempDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.cardCasualBackground)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .padding(.bottom, 6)
        }
        .background(Color.white)
        .frame(width: 330)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 0, y: 10)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        Color(white: 0.97).ignoresSafeArea()
        VStack(spacing: 20) {
            OutfitSuggestionCardView(type: .casual)
            OutfitSuggestionCardView(type: .work)
        }
        .padding(.horizontal, 20)
    }
}

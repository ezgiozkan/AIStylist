//
//  WardrobePowerCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import SwiftUI

struct WardrobePowerCard: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 30
        static let padding: CGFloat = 20
        static let buttonHeight: CGFloat = 46
        static let buttonCornerRadius: CGFloat = 23
        static let strokeWidth: CGFloat = 1
    }

    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("Your wardrobe powers your style")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(HomeViewConstants.primaryText)
                .multilineTextAlignment(.center)

            Text("The more items you add, the smarter your outfit recommendations become.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(HomeViewConstants.secondaryText)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            Button(action: onAdd) {
                Text("Add to wardrobe")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.buttonHeight)
                    .foregroundStyle(Color.buttonPrimary)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.buttonCornerRadius, style: .continuous)
                            .stroke(Color.buttonPrimary.opacity(0.9), lineWidth: 1.5)
                    }
            }
            .buttonStyle(.plain)
            .padding(.top, 6)
        }
        .padding(Constants.padding)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .fill(Color.buttonPrimary.opacity(0.06))
        )
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .stroke(Color.buttonPrimary.opacity(0.22), lineWidth: Constants.strokeWidth)
        }
    }
}

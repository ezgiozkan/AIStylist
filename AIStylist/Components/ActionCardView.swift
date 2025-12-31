//
//  ActionCardView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct ActionCardView: View {
    let type: ActionCardType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.buttonPrimary.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(type.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.buttonPrimary)
                }

                Text(type.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(type.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.black.opacity(0.7))
            }
            .frame(maxWidth: .infinity, minHeight: 160)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

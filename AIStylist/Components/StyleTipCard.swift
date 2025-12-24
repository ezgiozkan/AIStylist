//
//  StyleTipCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct StyleTipCard: View {
    let title: String
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.orange)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("STYLE TIP")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.gray)
                  

                Text(tip)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.cardCasualBackground)
                    .lineSpacing(4)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

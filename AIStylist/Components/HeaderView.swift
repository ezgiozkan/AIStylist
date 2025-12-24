//
//  HeaderView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

var headerView: some View {
    HStack(alignment: .center, spacing: 12) {
        ZStack {
            Circle()
                .fill(Color.purple.opacity(0.75))
                .frame(width: 44, height: 44)

            Text("E")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Hello, Ezgi 👋")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(HomeViewConstants.primaryText)

            Text("Let’s style your day")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(HomeViewConstants.secondaryText)
        }

        Spacer()

        Button(action: {}) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)

                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(HomeViewConstants.primaryText)
            }
        }
        .buttonStyle(.plain)
    }
    .padding(.horizontal, 20)
}

//
//  StyleTipCardSkeleton.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import SwiftUI

struct StyleTipCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 110, height: 16)
                .foregroundStyle(HomeViewConstants.primaryText.opacity(0.12))

            RoundedRectangle(cornerRadius: 10)
                .frame(height: 44)
                .foregroundStyle(HomeViewConstants.primaryText.opacity(0.10))

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 220, height: 18)
                .foregroundStyle(HomeViewConstants.primaryText.opacity(0.10))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.04))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        }
    }
}

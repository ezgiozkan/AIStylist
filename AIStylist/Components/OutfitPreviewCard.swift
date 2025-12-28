//
//  OutfitPreviewCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct OutfitPreviewCard: View {
    let isFilled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.black.opacity(0.03))

            if isFilled {
                HStack(spacing: 10) {
                    VStack(spacing: 6) {
                        Image(systemName: "tshirt")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black.opacity(0.45))
                        Image(systemName: "shirt")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black.opacity(0.45))
                    }
                    Image(systemName: "figure.walk")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(.black.opacity(0.45))
                }
            }
        }
        .frame(height: 96)
    }
}

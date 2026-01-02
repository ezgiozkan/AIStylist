//
//  AnalyzeStyleLoadingOverlay.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import SwiftUI

struct AnalyzeStyleLoadingOverlay: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Image("icon_analyze_style")
                .resizable()
                .scaledToFill()
                .scaleEffect(isAnimating ? 1.06 : 1.0)
                .opacity(isAnimating ? 1.0 : 0.92)
                .ignoresSafeArea()
                .animation(
                    .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                    value: isAnimating
                )

            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Matching items from your wardrobe...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .padding(.top, 140)

                Spacer()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

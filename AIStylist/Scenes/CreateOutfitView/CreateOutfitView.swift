//
//  CreateOutfitView().swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct CreateOutfitView: View {
    private enum UI {
        static let horizontalPadding: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 28
        static let bottomInsetPadding: CGFloat = 12
    }

    private func onAnalyzePressed() {}

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {


            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.buttonPrimary.opacity(0.08))
                        .frame(width: 260, height: 260)

                    Circle()
                        .fill(Color.buttonPrimary.opacity(0.10))
                        .frame(width: 200, height: 200)

                    Circle()
                        .fill(Color.buttonPrimary.opacity(0.14))
                        .frame(width: 140, height: 140)

                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 78, height: 78)
                        .shadow(radius: 10, y: 6)

                    Image("icon_analyze")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.buttonPrimary)
                }
                .padding(.top, 6)

                Text("See an item you like? Upload a photo and we’ll identify it.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 14) {
                FeatureRow(
                    icon: "camera.fill",
                    title: "Screenshot anything",
                    subtitle: "Instagram posts, TikToks, magazines — anywhere you spot style"
                )

                FeatureRow(
                    icon: "magnifyingglass",
                    title: "Smart recognition",
                    subtitle: "We identify every clothing item and accessory automatically"
                )
            }
            .padding(.horizontal, UI.horizontalPadding)

            VStack(alignment: .leading, spacing: 10) {
                Text("FOR BEST RESULTS")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)

                TipRow(icon: "camera.fill", text: "Make sure the item is clearly visible")
                TipRow(icon: "sun.max.fill", text: "Use bright, natural lighting")
                TipRow(icon: "wand.and.stars", text: "Avoid heavy filters or obstructions")
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onAnalyzePressed) {
                HStack(spacing: 10) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Analyze Photo")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.buttonPrimary)
                .cornerRadius(UI.buttonCornerRadius)
            }
            .padding(.horizontal, UI.horizontalPadding)
            .padding(.top, 12)
            }
            .padding(.bottom, 36)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    CreateOutfitView()
}

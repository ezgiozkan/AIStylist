//
//  SavedToWardrobeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct SavedToWardrobeView: View {
    @StateObject private var viewModel: SavedToWardrobeViewModel

    let onViewWardrobe: () -> Void
    let onDone: () -> Void

    init(
        response: UploadClothingResponse,
        onViewWardrobe: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: SavedToWardrobeViewModel(response: response))
        self.onViewWardrobe = onViewWardrobe
        self.onDone = onDone
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: onDone) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                    }
                }

                Text(viewModel.titleText)
                    .font(.system(size: 28, weight: .bold))

                Text(viewModel.subtitleText)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    Text("NEW ADDITION")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)

                    Text(viewModel.itemTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)

                    if !viewModel.itemSubtitle.isEmpty {
                        Text(viewModel.itemSubtitle)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))

                Button(action: onViewWardrobe) {
                    Text(viewModel.primaryCTAText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                }
                .buttonStyle(.borderedProminent)

                Button(action: onDone) {
                    Text(viewModel.secondaryCTAText)
                }
                .padding(.bottom, 6)
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 28).fill(Color(.systemBackground)))
            .padding(.horizontal, 20)
        }
    }
}

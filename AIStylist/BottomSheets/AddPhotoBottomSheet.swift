//
//  AddPhotoBottomSheet.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import SwiftUI

struct AddPhotoBottomSheet: View {

    let onTakePhoto: () -> Void
    let onChooseFromGallery: () -> Void

    var body: some View {
        VStack(spacing: 16) {

            Capsule()
                .fill(Color.secondary.opacity(0.25))
                .frame(width: 44, height: 5)
                .padding(.top, 10)

            Text("Add a photo")
                .font(.system(size: 22, weight: .semibold))
                .kerning(0)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .allowsTightening(true)
                .padding(.top, 2)

            Text("Choose how you want to upload your image")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            VStack(spacing: 14) {
                ActionRow(
                    icon: "camera.fill",
                    title: "Take Photo",
                    subtitle: "Use your camera",
                    action: onTakePhoto
                )

                ActionRow(
                    icon: "photo.on.rectangle",
                    title: "Choose from Gallery",
                    subtitle: "Select from your library",
                    action: onChooseFromGallery
                )
            }
            .padding(.top, 6)
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}

#Preview {
    AddPhotoBottomSheet(
        onTakePhoto: {},
        onChooseFromGallery: {}
    )
}

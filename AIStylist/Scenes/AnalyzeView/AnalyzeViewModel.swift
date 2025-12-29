//
//  AnalyzeViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import SwiftUI

@MainActor
final class AnalyzeViewModel: ObservableObject {
    private let accessToken: String?
    @Published var step: Step = .imageUploaded
    @Published var isScanning = true
    @Published var response: UploadClothingResponse?
    @Published var isShowingSuccess = false
    @Published var errorMessage: String?
    @Published var lastSelectedImage: UIImage?

    private let service: ClothingUploadServicing
    private enum Constants {
        static let stepAdvanceDelayNanos: UInt64 = 700_000_000
    }

    init(
        service: ClothingUploadServicing = ClothingUploadService(),
        accessToken: String?
    ) {
        self.service = service
        self.accessToken = accessToken
    }

    func start(image: UIImage) {
        lastSelectedImage = image
        Task { await upload(image: image) }
    }

    func upload(image: UIImage) async {
        errorMessage = nil
        response = nil
        isShowingSuccess = false
        step = .imageUploaded
        isScanning = true

        guard let pngData = image.pngData() else {
            errorMessage = "Image encoding failed"
            step = .failed
            isScanning = false
            return
        }

        step = .detectingItems

        do {
            let decoded = try await service.uploadClothing(pngData: pngData, accessToken: accessToken)
            response = decoded

            step = .generatingLookbook
            try? await Task.sleep(nanoseconds: Constants.stepAdvanceDelayNanos)

            step = .completed
            isScanning = false
            isShowingSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            step = .failed
            isScanning = false
        }
    }
}

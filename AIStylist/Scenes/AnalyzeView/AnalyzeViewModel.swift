//
//  AnalyzeViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import SwiftUI

@MainActor
final class AnalyzeViewModel: ObservableObject {
    private let service: ClothingUploadServicing
    private let wardrobeService: WardrobeServicing
    private let accessToken: String?
    @Published var step: Step = .imageUploaded
    @Published var isScanning = true
    @Published var response: UploadClothingResponse?
    @Published var wardrobeItem: WardrobeItemResponse?
    @Published var isShowingSuccess = false
    @Published var errorMessage: String?
    @Published var lastSelectedImage: UIImage?

    private enum Constants {
        static let stepAdvanceDelayNanos: UInt64 = 700_000_000
    }

    init(
        service: ClothingUploadServicing = ClothingUploadService(),
        wardrobeService: WardrobeServicing = WardrobeService(),
        accessToken: String?
    ) {
        self.service = service
        self.wardrobeService = wardrobeService
        self.accessToken = accessToken
    }

    func start(image: UIImage) {
        lastSelectedImage = image
        Task { await upload(image: image) }
    }

    func upload(image: UIImage) async {
        errorMessage = nil
        response = nil
        wardrobeItem = nil
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

            guard let itemId = decoded.id, !itemId.isEmpty else {
                errorMessage = "Wardrobe item id not found"
                step = .failed
                isScanning = false
                return
            }

            let resolvedToken = AuthTokenProvider.token ?? accessToken
            guard let token = resolvedToken, !token.isEmpty else {
                errorMessage = "Authentication token not found"
                step = .failed
                isScanning = false
                return
            }

            step = .generatingLookbook
            let item = try await fetchWardrobeItemUntilReady(id: itemId, token: token)
            wardrobeItem = item

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

    private func fetchWardrobeItemUntilReady(id: String, token: String) async throws -> WardrobeItemResponse {
        let maxAttempts = 12
        let delayNanos: UInt64 = 1_000_000_000

        for attempt in 1...maxAttempts {
            do {
                let item = try await wardrobeService.fetchWardrobeItem(id: id, accessToken: token)

                let status = item.status.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                let imageEmpty = item.imageURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

                if status == "PROCESSING" || imageEmpty {
                    print("⏳ Wardrobe item not ready (attempt \(attempt)/\(maxAttempts)) status=\(status) imageEmpty=\(imageEmpty)")
                } else {
                    print("✅ Wardrobe item ready (attempt \(attempt)/\(maxAttempts)) status=\(status)")
                    return item
                }
            } catch let httpError as WardrobeHTTPError {
                if httpError.statusCode == 422 {
                    print("⏳ Wardrobe fetch 422 while processing (attempt \(attempt)/\(maxAttempts))")
                } else {
                    print("❌ Wardrobe fetch failed with HTTP \(httpError.statusCode)")
                    throw httpError
                }
            } catch let decoding as DecodingError {
                // Backend sometimes returns a non-final payload (or error payload) that doesn't match the model yet.
                // Treat decode failures as retryable while polling.
                print("⏳ Wardrobe decode failed while processing (attempt \(attempt)/\(maxAttempts)):", String(describing: decoding))
            } catch {
                print("❌ Wardrobe fetch failed (attempt \(attempt)/\(maxAttempts)):", error.localizedDescription)
                throw error
            }

            try? await Task.sleep(nanoseconds: delayNanos)
        }

        throw WardrobeHTTPError(statusCode: 408, data: Data("Wardrobe item processing timed out".utf8))
    }
}

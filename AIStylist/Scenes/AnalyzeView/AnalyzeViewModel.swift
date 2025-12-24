import SwiftUI

@MainActor
final class AnalyzeViewModel: ObservableObject {
    @Published var step: Step = .imageUploaded
    @Published var isScanning = true
    @Published var response: UploadClothingResponse?
    @Published var errorMessage: String?

    private let service: ClothingUploadServicing
    private enum Constants {
        static let stepAdvanceDelayNanos: UInt64 = 700_000_000
    }

    init(service: ClothingUploadServicing = ClothingUploadService()) {
        self.service = service
    }

    func start(image: UIImage) {
        Task { await upload(image: image) }
    }

    func upload(image: UIImage) async {
        errorMessage = nil
        response = nil
        step = .imageUploaded
        isScanning = true

        guard let pngData = image.pngData() else {
            errorMessage = "Image encoding failed"
            isScanning = false
            return
        }

        step = .detectingItems

        do {
            let decoded = try await service.uploadClothing(pngData: pngData)

            step = .generatingLookbook
            try? await Task.sleep(nanoseconds: Constants.stepAdvanceDelayNanos)

            response = decoded
            step = .completed
            isScanning = false
        } catch {
            errorMessage = error.localizedDescription
            isScanning = false
        }
    }
}

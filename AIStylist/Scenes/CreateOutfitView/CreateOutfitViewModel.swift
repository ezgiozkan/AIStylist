//
//  CreateOutfitViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI
import UIKit
import AVFoundation
import Photos

@MainActor
final class CreateOutfitViewModel: ObservableObject {

    @Published var isAddPhotoPickerPresented: Bool = false
    @Published var addPhotoPickerDragOffset: CGFloat = 0

    @Published var isImagePickerPresented: Bool = false
    @Published var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    @Published var isPreparingImagePicker: Bool = false

    @Published var selectedImage: UIImage?
    @Published var pendingAnalyzeImage: UIImage?
    @Published var analyzePayload: AnalyzeModel?

    func showAddPhotoPicker() {
        isAddPhotoPickerPresented = true
    }

    func dismissAddPhotoPicker() {
        isAddPhotoPickerPresented = false
        addPhotoPickerDragOffset = 0
        isPreparingImagePicker = false
    }

    func presentImagePicker(source: UIImagePickerController.SourceType) {
        imagePickerSourceType = source
        dismissAddPhotoPicker()
        isPreparingImagePicker = false
        isImagePickerPresented = true
    }

    func requestCameraPermissionAndPresent() {
        isPreparingImagePicker = true

        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            isPreparingImagePicker = false
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePicker(source: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    guard granted else {
                        self?.isPreparingImagePicker = false
                        return
                    }
                    self?.presentImagePicker(source: .camera)
                }
            }
        default:
            isPreparingImagePicker = false
        }
    }

    func requestPhotoLibraryPermissionAndPresent() {
        isPreparingImagePicker = true

        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            presentImagePicker(source: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                Task { @MainActor in
                    guard newStatus == .authorized || newStatus == .limited else {
                        self?.isPreparingImagePicker = false
                        return
                    }
                    self?.presentImagePicker(source: .photoLibrary)
                }
            }
        default:
            isPreparingImagePicker = false
        }
    }

    func handleSelectedImageChange(_ newValue: UIImage?) {
        guard let newValue else { return }
        isPreparingImagePicker = false
        pendingAnalyzeImage = newValue
        isImagePickerPresented = false
        selectedImage = nil
    }

    func handleImagePickerDismiss() {
        isPreparingImagePicker = false
        guard let image = pendingAnalyzeImage else { return }
        analyzePayload = AnalyzeModel(image: image)
        pendingAnalyzeImage = nil
    }

    func clearAnalyzePayload() {
        analyzePayload = nil
    }
}

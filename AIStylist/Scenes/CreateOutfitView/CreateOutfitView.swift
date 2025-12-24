//
//  CreateOutfitView().swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Photos

struct CreateOutfitView: View {
    private enum UI {
        static let horizontalPadding: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 28
        static let bottomInsetPadding: CGFloat = 12
    }

    @State private var isAddPhotoPickerPresented = false
    @State private var addPhotoPickerDragOffset: CGFloat = 0
    @State private var isImagePickerPresented = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var imageToAnalyze: UIImage?
    @State private var isAnalyzePresented = false

    private func onAnalyzePressed() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            isAddPhotoPickerPresented = true
        }
    }

    private func dismissAddPhotoPicker() {
        isAddPhotoPickerPresented = false
        addPhotoPickerDragOffset = 0
    }

    private var addPhotoPicker: some View {
        AddPhotoBottomSheet(
            onTakePhoto: {
                requestCameraPermissionAndPresent()
            },
            onChooseFromGallery: {
                requestPhotoLibraryPermissionAndPresent()
            }
        )
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .offset(y: max(0, addPhotoPickerDragOffset))
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        addPhotoPickerDragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 120 {
                        dismissAddPhotoPicker()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            addPhotoPickerDragOffset = 0
                        }
                    }
                }
        )
        .frame(height: 295)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
    }

    private func requestCameraPermissionAndPresent() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePicker(source: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        presentImagePicker(source: .camera)
                    }
                }
            }
        default:
            break
        }
    }

    private func requestPhotoLibraryPermissionAndPresent() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            presentImagePicker(source: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        presentImagePicker(source: .photoLibrary)
                    }
                }
            }
        default:
            break
        }
    }

    private func presentImagePicker(source: UIImagePickerController.SourceType) {
        imagePickerSourceType = source
        dismissAddPhotoPicker()
        isImagePickerPresented = true
    }

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    content
                }
            } else {
                NavigationView {
                    content
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }

    private var content: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(spacing: 14) {
                        ZStack {
                            Image("icon_analyze")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330, height: 330)
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
                            Text("Upload Photo")
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

            if isAddPhotoPickerPresented {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissAddPhotoPicker()
                    }

                VStack(spacing: 0) {
                    Spacer()
                    addPhotoPicker
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: [.bottom, .horizontal])
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(sourceType: imagePickerSourceType, selectedImage: $selectedImage)
                .ignoresSafeArea()
        }
        .onChange(of: selectedImage) { newValue in
            guard let newValue else { return }
            imageToAnalyze = newValue
            isAnalyzePresented = true
        }
        .fullScreenCover(isPresented: $isAnalyzePresented) {
            if let imageToAnalyze {
                AnalyzeView(image: imageToAnalyze, onCancel: {
                    isAnalyzePresented = false
                })
            }
        }
    }
}


private struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    CreateOutfitView()
}

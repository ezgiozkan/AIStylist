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
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var viewModel = CreateOutfitViewModel()

    private var addPhotoPicker: some View {
        AddPhotoBottomSheet(
            onTakePhoto: {
                viewModel.requestCameraPermissionAndPresent()
            },
            onChooseFromGallery: {
                viewModel.requestPhotoLibraryPermissionAndPresent()
            }
        )
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .offset(y: max(0, viewModel.addPhotoPickerDragOffset))
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        viewModel.addPhotoPickerDragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 120 {
                        viewModel.dismissAddPhotoPicker()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            viewModel.addPhotoPickerDragOffset = 0
                        }
                    }
                }
        )
        .frame(height: 295)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
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
                    .padding(.horizontal, CreateOutfitConstants.horizontalPadding)

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

                    Button(action: { withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) { viewModel.showAddPhotoPicker() } }) {
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
                        .cornerRadius(CreateOutfitConstants.buttonCornerRadius)
                    }
                    .padding(.horizontal, CreateOutfitConstants.horizontalPadding)
                    .padding(.top, 12)
                }
                .padding(.bottom, 36)
            }
            .background(Color(.systemBackground))

            if viewModel.isAddPhotoPickerPresented {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissAddPhotoPicker()
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

            if viewModel.isPreparingImagePicker {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .zIndex(2)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.15)
                    .zIndex(3)
            }
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented, onDismiss: {
            viewModel.handleImagePickerDismiss()
            viewModel.isPreparingImagePicker = false
        }) {
            ImagePicker(sourceType: viewModel.imagePickerSourceType, selectedImage: $viewModel.selectedImage)
                .ignoresSafeArea()
        }
        .onChange(of: viewModel.selectedImage) { newValue in
            viewModel.handleSelectedImageChange(newValue)
            viewModel.isPreparingImagePicker = false
        }
        .fullScreenCover(item: $viewModel.analyzePayload) { payload in
            AnalyzeView(image: payload.image, accessToken: authVM.accessToken, onCancel: {
                viewModel.clearAnalyzePayload()
            })
        }
    }
}

#Preview {
    CreateOutfitView()
}

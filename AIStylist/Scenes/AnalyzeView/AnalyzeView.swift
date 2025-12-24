//
//  AnalyzeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import SwiftUI

struct AnalyzeView: View {
    let image: UIImage
    var onCancel: (() -> Void)?

    @StateObject private var viewModel = AnalyzeViewModel()
    @State private var scanProgress: CGFloat = 0
    @State private var isAnimatingScan = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                imageCard
                    .padding(.top, 24)
                    .padding(.horizontal, 24)

                VStack(spacing: 10) {
                    Text("Analyzing your style...")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text("Identifying fabrics, patterns, and cuts\nfrom your photo.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineSpacing(4)
                }
                .padding(.top, AnalyzeViewConstants.contentSpacing)
                .padding(.horizontal, 24)

                steps
                    .padding(.top, 16)
                    .padding(.horizontal, 24)

                Spacer(minLength: 0)
            }
        }
        .onAppear {
            viewModel.start(image: image)
            updateScanningAnimation(isScanning: viewModel.isScanning)
        }
        .onChange(of: viewModel.isScanning) { newValue in
            updateScanningAnimation(isScanning: newValue)
        }
        .onDisappear {
            stopAnimating()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .hideNavigationBarBackgroundIfAvailable()
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(true)
        .background(DisablePopGesture())
    }


    private var imageCard: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: AnalyzeViewConstants.imageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()

                scanOverlay
            }
            .frame(height: AnalyzeViewConstants.imageHeight)
            .clipped()

            processingPill
                .padding(.bottom, AnalyzeViewConstants.processingPillBottomPadding)
        }
        .frame(height: AnalyzeViewConstants.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: AnalyzeViewConstants.imageCornerRadius, style: .continuous))
    }

    private var processingPill: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 14, weight: .semibold))

            Text("AI PROCESSING")
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, AnalyzeViewConstants.processingPillHorizontalPadding)
        .frame(height: AnalyzeViewConstants.processingPillHeight)
        .background(
            Capsule(style: .continuous)
                .fill(Color.black.opacity(0.22))
        )
    }

    private var scanOverlay: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let y = max(0, min(height, (isAnimatingScan ? scanProgress : 0) * height))

            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black.opacity(0.10))

                Rectangle()
                    .fill(Color.purple.opacity(0.22))
                    .frame(height: y)
                    .frame(maxWidth: .infinity, alignment: .top)

                scanLine
                    .offset(y: y - (AnalyzeViewConstants.scanLineHeight / 2))
            }
            .allowsHitTesting(false)
        }
    }

    private var scanLine: some View {
        Rectangle()
            .fill(Color.purple)
            .frame(height: AnalyzeViewConstants.scanLineHeight)
            .shadow(color: Color.purple.opacity(0.9), radius: 10, x: 0, y: 0)
            .shadow(color: Color.purple.opacity(0.5), radius: 18, x: 0, y: 0)
    }

    private var steps: some View {
        VStack(spacing: 18) {
            stepRow(
                icon: stepIcon(for: .imageUploaded),
                title: "Image uploaded",
                subtitle: stepSubtitle(for: Step.imageUploaded),
                isActive: viewModel.step == Step.imageUploaded,
                isDone: viewModel.step.rawValue > Step.imageUploaded.rawValue
            )

            stepRow(
                icon: stepIcon(for: .detectingItems),
                title: "Detecting items",
                subtitle: stepSubtitle(for: .detectingItems),
                isActive: viewModel.step == .detectingItems,
                isDone: viewModel.step.rawValue > Step.detectingItems.rawValue
            )

            stepRow(
                icon: stepIcon(for: .generatingLookbook),
                title: "Generating lookbook",
                subtitle: stepSubtitle(for: .generatingLookbook),
                isActive: viewModel.step == .generatingLookbook,
                isDone: viewModel.step.rawValue > Step.generatingLookbook.rawValue
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private func stepIcon(for step: Step) -> AnyView {
        if viewModel.step.rawValue > step.rawValue {
            return AnyView(
                ZStack {
                    Circle().fill(Color.purple.opacity(0.16)).frame(width: 24, height: 24)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.purple)
                }
            )
        }

        if viewModel.step == step {
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.purple)
                    .frame(width: 24, height: 24)
            )
        }

        return AnyView(
            Circle()
                .strokeBorder(Color.secondary.opacity(0.25), lineWidth: 2)
                .frame(width: 24, height: 24)
        )
    }

    private func stepSubtitle(for step: Step) -> String {
        if viewModel.step.rawValue > step.rawValue {
            return "Done"
        }
        if viewModel.step == step {
            return "Processing..."
        }
        return "Pending"
    }

    private func stepRow(icon: AnyView, title: String, subtitle: String, isActive: Bool, isDone: Bool) -> some View {
        HStack(alignment: .top, spacing: 14) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isDone ? .primary : .primary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(isActive ? Color.purple : .secondary)
            }

            Spacer(minLength: 0)
        }
    }

    private func updateScanningAnimation(isScanning: Bool) {
        if isScanning {
            startAnimating()
        } else {
            stopAnimating()
        }
    }

    private func startAnimating() {
        guard !isAnimatingScan else { return }
        isAnimatingScan = true

        scanProgress = 0
        withAnimation(.linear(duration: AnalyzeViewConstants.scanDuration).repeatForever(autoreverses: false)) {
            scanProgress = 1
        }
    }

    private func stopAnimating() {
        isAnimatingScan = false
        scanProgress = 0
    }
}

private struct DisablePopGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Controller()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private final class Controller: UIViewController {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

private extension View {
    @ViewBuilder
    func hideNavigationBarBackgroundIfAvailable() -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarBackground(.hidden, for: .navigationBar)
        } else {
            self
        }
    }
}

#Preview {
    AnalyzeView(image: UIImage(systemName: "person.fill") ?? UIImage(), onCancel: nil)
}

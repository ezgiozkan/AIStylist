//
//  RecommendOutfitView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import SwiftUI

struct RecommendOutfitView: View {

    @StateObject private var viewModel = RecommendOutfitViewModel()
    @State private var isShowingResult = false

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    header

                    Text("Choose an occasion")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Colors.primaryText)
                        .padding(.top, 6)

                    occasionGrid
                        .padding(.top, 2)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, Layout.topPadding)
                .padding(.bottom, Layout.scrollBottomPadding)
            }
            .background(Colors.screenBackground.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            .onReceive(viewModel.$generatedOutfit) { newValue in
                isShowingResult = (newValue != nil)
            }

            if viewModel.isGenerating {
                AnalyzeStyleLoadingOverlay()
            }
        }
        .fullScreenCover(isPresented: $isShowingResult) {
            if let response = viewModel.generatedOutfit {
                OutfitResultView(response: response) {
                    isShowingResult = false
                }
            } else {
                Color.clear
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Plan an occasion")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Colors.primaryText)

            Text("Dress right for the moment")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Colors.purple)

            Text("Outfit suggestions are built from the items you’ve added to your wardrobe. The more you add, the smarter and more personalized Style AI recommendations become.")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Colors.secondaryText)
                .lineSpacing(3)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var occasionGrid: some View {
        LazyVGrid(columns: Layout.gridColumns, spacing: Layout.gridSpacing) {
            ForEach(viewModel.occasions) { item in
                OccasionCard(
                    item: item,
                    isSelected: viewModel.selectedOccasionID == item.id
                ) {
                    viewModel.select(item.id)
                }
            }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 10) {
            Button {
                print("🟣 Generate button tapped")
                viewModel.generateTapped(token: "", weather: "cold")
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Generate outfit with AI")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.primaryButtonHeight)
                .background(
                    RoundedRectangle(cornerRadius: Layout.primaryButtonCornerRadius, style: .continuous)
                        .fill(Colors.primaryButton)
                )
                .shadow(color: Colors.primaryButtonShadow, radius: 24, x: 0, y: 10)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.selectedOccasionID == nil || viewModel.isGenerating)
            .opacity((viewModel.selectedOccasionID == nil || viewModel.isGenerating) ? 0.55 : 1)

            Text("You’ll get 2–3 outfit options.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Colors.secondaryText)
                .padding(.bottom, 4)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, 14)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Colors.screenBackground.opacity(0.0),
                    Colors.screenBackground.opacity(0.98),
                    Colors.screenBackground
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

extension RecommendOutfitView {
    enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 18
        static let scrollBottomPadding: CGFloat = 120

        static let gridSpacing: CGFloat = 16
        static let cardHeight: CGFloat = 170
        static let cardCornerRadius: CGFloat = 28

        static let primaryButtonHeight: CGFloat = 64
        static let primaryButtonCornerRadius: CGFloat = 34

        static let gridColumns: [GridItem] = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    }

    enum Colors {
        static let screenBackground = Color(red: 0.97, green: 0.97, blue: 0.98)

        static let primaryText = Color(red: 0.10, green: 0.10, blue: 0.13)
        static let secondaryText = Color(red: 0.52, green: 0.52, blue: 0.60)

        static let purple = Color(red: 0.52, green: 0.33, blue: 0.94)
        static let pillBackground = Color(red: 0.92, green: 0.90, blue: 0.98)

        static let iconBackground = Color.black.opacity(0.05)

        static let primaryButton = Color(red: 0.52, green: 0.33, blue: 0.94)
        static let primaryButtonShadow = Color(red: 0.52, green: 0.33, blue: 0.94).opacity(0.30)

        static let cardShadow = Color.black.opacity(0.06)
    }
}

extension View {
    func aiStylistOutfitResultView(
        response: RecommendOutfitResponse,
        onClose: @escaping () -> Void
    ) -> some View {
        OutfitResultView(response: response, onClose: onClose)
    }
}

#Preview {
    RecommendOutfitView()
}

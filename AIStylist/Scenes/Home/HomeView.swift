//
//  HomeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 25.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        ZStack {
            HomeViewConstants.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                header
                weatherRow

                Text("Based on today’s weather, here are smart outfit ideas tailored just for you.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(HomeViewConstants.secondaryText)
                    .padding(.horizontal, 16)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        OutfitSuggestionCardView(
                            style: .casual,
                            background: HomeViewConstants.cardCasualBackground,
                            subtitle: "Oversized knit beige sweater, straight-leg denim, and white sneakers."
                        )

                        OutfitSuggestionCardView(
                            style: .work,
                            background: HomeViewConstants.cardWorkBackground,
                            subtitle: "Navy blazer, crisp shirt, and grey trousers."
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                .frame(height: 220)

                StyleTipCard(
                    title: "Style Tip of the Day",
                    tip: "Monochrome outfits elongate your silhouette. Try matching your shoes to your pants today."
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 0)
            }
            .padding(.top, 24)
        }
        .onAppear {
            viewModel.load()
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.75))
                    .frame(width: 44, height: 44)
                Text("E")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, Ezgi 👋")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(HomeViewConstants.primaryText)

                Text("Let’s style your day")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(HomeViewConstants.secondaryText)
            }

            Spacer()

            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)

                    Image(systemName: "bell")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(HomeViewConstants.primaryText)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    private var weatherRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "sun.max")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.purple.opacity(0.75))

            Text(viewModel.weatherText)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(HomeViewConstants.primaryText)

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    HomeView()
}

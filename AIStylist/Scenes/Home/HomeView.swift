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

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerView
                    weatherRow

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Based on today’s weather, here are smart outfit ideas tailored just for you.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(HomeViewConstants.secondaryText)
                            .lineSpacing(4)
                            .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                OutfitSuggestionCardView(type: .casual)
                                OutfitSuggestionCardView(type: .work)
                            }
                            .padding(.horizontal, 20)
                            .background(Color.clear)
                        }
                        .background(Color.clear)

                        StyleTipCard(
                            title: "Style Tip",
                            tip: "Balance proportions by pairing relaxed fits with structured pieces."
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        HStack(spacing: 16) {
                            ActionCardView(type: .occasion) {
                                // navigate to Plan an Occasion
                            }

                            ActionCardView(type: .travel) {
                                // navigate to Travel Capsule
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }

                    Spacer(minLength: 0)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            FloatingCreateButton {
                // TODO: navigate to Create
            }
            .padding(.trailing, 20)
            .padding(.bottom, 12)
        }
        .onAppear {
            viewModel.load()
        }
    }
}

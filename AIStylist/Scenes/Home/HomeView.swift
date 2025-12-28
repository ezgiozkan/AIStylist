//
//  HomeView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 25.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showWardrobePicker = false
    @State private var showCalendar = false
    @State private var showCreateOutfit = false
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                HomeViewConstants.background.ignoresSafeArea()

                NavigationLink(
                    destination: WardrobePickerView().hideTabBarOnPush(),
                    isActive: $showWardrobePicker,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: OutfitCalendarView().hideTabBarOnPush(),
                    isActive: $showCalendar,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: CreateOutfitView().hideTabBarOnPush(),
                    isActive: $showCreateOutfit,
                    label: { EmptyView() }
                )
                .hidden()

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

                            OutfitCalendarSectionView(
                                items: [
                                    .init(title: "Today", subtitle: "Dec 12", weatherSymbol: "sun.max", tempText: "15°", state: .planned(imageName: "icon_casual")),
                                    .init(title: "Tomorrow", subtitle: "Dec 13", weatherSymbol: "cloud", tempText: "12°", state: .empty),
                                    .init(title: "Sun", subtitle: "Dec 14", weatherSymbol: "cloud.sun", tempText: "11°", state: .planned(imageName: "icon_work"))
                                ],
                                onSeeAll: {
                                    showCalendar = true
                                },
                                onTapDay: { day in
                                    // handle day tap
                                },
                                onTapEmptyPlan: { _ in
                                    showWardrobePicker = true
                                }
                            )
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
                    showCreateOutfit = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 12)
            }
            .onAppear {
                viewModel.load()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }


    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \((authVM.signedInUser?.fullName?.split(separator: " ").first.map(String.init)) ?? "there")")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(HomeViewConstants.primaryText)

                Text("What’s your style today?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(HomeViewConstants.secondaryText)
            }

            Spacer()

            Group {
                if let urlString = authVM.signedInUser?.avatarURL,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(HomeViewConstants.primaryText)
                        }
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(HomeViewConstants.primaryText)
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
        }
        .padding(.horizontal, 20)
    }


    var weatherRow: some View {
        HStack(spacing: 10) {
            if viewModel.isWeatherLoading {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.purple.opacity(0.18))

                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 220, height: 18)
                    .foregroundStyle(HomeViewConstants.primaryText.opacity(0.12))
            } else {
                Image(systemName: viewModel.weatherSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.purple.opacity(0.75))

                Text(viewModel.weatherText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(HomeViewConstants.primaryText)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isWeatherLoading)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
#endif

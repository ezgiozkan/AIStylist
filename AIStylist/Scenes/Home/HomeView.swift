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
    @State private var planningDayKey: String = ""
    @State private var showCalendar = false
    @State private var showCreateOutfit = false
    @State private var showTravel = false
    @State private var showRecommendOutfit = false
    @EnvironmentObject var authVM: AuthViewModel
    @AppStorage("aiStylist_currentTab") private var currentTab: Int = AppTab.home.rawValue

    var body: some View {
        NavigationView {
            ZStack {
                HomeViewConstants.background.ignoresSafeArea()

                NavigationLink(
                    destination: LazyView { WardrobePickerView(planDayKey: planningDayKey).hideTabBarOnPush() },
                    isActive: $showWardrobePicker,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: LazyView { OutfitCalendarView().hideTabBarOnPush() },
                    isActive: $showCalendar,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: LazyView { CreateOutfitView().hideTabBarOnPush() },
                    isActive: $showCreateOutfit,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: LazyView { TravelView().hideTabBarOnPush() },
                    isActive: $showTravel,
                    label: { EmptyView() }
                )
                .hidden()

                NavigationLink(
                    destination: LazyView { RecommendOutfitView().hideTabBarOnPush() },
                    isActive: $showRecommendOutfit,
                    label: { EmptyView() }
                )
                .hidden()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerView
                        weatherRow

                        VStack(alignment: .leading, spacing: 16) {
                            if viewModel.isTodayPickLoading {
                                TodayPickHeroCardSkeleton(height: 380)
                                    .padding(.horizontal, 20)
                            } else {
                                Color.clear
                                    .aiStylistTodayPickCard(
                                        imageName: "",
                                        remoteImageURL: viewModel.todayPickImageURL,
                                        pillText: "TODAY’S PICK",
                                        title: viewModel.todayPickTitle,
                                        subtitle: viewModel.todayPickDescription
                                    )
                                    .padding(.horizontal, 20)
                            }

                            Text("Daily Style Tip")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(HomeViewConstants.primaryText)
                                .padding(.horizontal, 20)
                                .padding(.top, 2)

                            if viewModel.isTipLoading {
                                StyleTipCardSkeleton()
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                            } else {
                                StyleTipCard(
                                    tip: viewModel.styleTipText
                                )
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            }

                            WardrobePowerCard {
                                showCreateOutfit = true
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                            HStack(spacing: 16) {
                                ActionCardView(type: .occasion) {
                                    showRecommendOutfit = true
                                }

                                ActionCardView(type: .travel) {
                                    showTravel = true
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                            if false {
                                OutfitCalendarSectionView(
                                    items: viewModel.calendarItems,
                                    onSeeAll: {
                                        showCalendar = true
                                    },
                                    onTapDay: { day in
                                        // handle day tap
                                    },
                                    onTapEmptyPlan: { day in
                                        planningDayKey = day.id
                                        showWardrobePicker = true
                                    }
                                )
                                .padding(.top, 16)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                viewModel.loadIfNeeded()
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
                    .foregroundStyle(Color.buttonPrimary.opacity(0.18))

                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 220, height: 18)
                    .foregroundStyle(HomeViewConstants.primaryText.opacity(0.12))
            } else {
                Image(systemName: viewModel.weatherSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.buttonPrimary.opacity(0.75))

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

extension View {
    func aiStylistTodayPickCard(
        imageName: String,
        remoteImageURL: String?,
        pillText: String,
        title: String,
        subtitle: String,
        height: CGFloat = 380
    ) -> some View {
        TodayPickHeroCard(
            imageName: imageName,
            remoteImageURL: remoteImageURL,
            pillText: pillText,
            title: title,
            subtitle: subtitle,
            height: height
        )
    }
}

private struct LazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

private struct TodayPickHeroCardSkeleton: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 28
        static let height: CGFloat = 380
        static let topPillPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 18
        static let sidePadding: CGFloat = 18
    }

    let height: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .fill(HomeViewConstants.primaryText.opacity(0.06))
                .frame(height: height)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(HomeViewConstants.primaryText.opacity(0.10))
                        .frame(width: 110, height: 28)

                    Spacer()
                }
                .padding(.top, Constants.topPillPadding)
                .padding(.horizontal, Constants.sidePadding)

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(HomeViewConstants.primaryText.opacity(0.10))
                        .frame(width: 220, height: 26)

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(HomeViewConstants.primaryText.opacity(0.10))
                        .frame(width: 280, height: 18)
                }
                .padding(.horizontal, Constants.sidePadding)
                .padding(.bottom, Constants.bottomPadding)
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }
}

private struct TodayPickHeroCard: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 28
        static let topPillPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 18
        static let sidePadding: CGFloat = 18
    }

    let imageName: String
    let remoteImageURL: String?
    let pillText: String
    let title: String
    let subtitle: String
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if let remoteImageURL,
                   let url = URL(string: remoteImageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Image(imageName).resizable().scaledToFill()
                        }
                    }
                } else {
                    Image(imageName).resizable().scaledToFill()
                }
            }
            .frame(height: height)
            .clipped()

            // Darken bottom for readable text
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.0), location: 0.0),
                    .init(color: .black.opacity(0.55), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(pillText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.92))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.white.opacity(0.18))
                        )

                    Spacer()
                }
                .padding(.top, Constants.topPillPadding)
                .padding(.horizontal, Constants.sidePadding)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.85))
                        .lineSpacing(2)
                }
                .padding(.horizontal, Constants.sidePadding)
                .padding(.bottom, Constants.bottomPadding)
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
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

//
//  CustomTabBar.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI
import UIKit

struct TabBarView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: AppTab = .home
    @State private var lastNonCreateTab: AppTab = .home
    @State private var showCreateOptionsSheet: Bool = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .separator

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = .secondaryLabel
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18.0, *) {
                    TabView(selection: $selectedTab) {
                        Tab("Home", systemImage: "house", value: .home) {
                            HomeView().environmentObject(authVM)
                        }

                        Tab("Wardrobe", systemImage: "sparkles", value: .wardrobe) {
                            WardrobeView().environmentObject(authVM)
                        }

                        Tab("Create", systemImage: "wand.and.stars", value: .create) {
                            Color.clear
                        }

                        Tab("Travel", systemImage: "airplane", value: .travel) {
                            TravelView().environmentObject(authVM)
                        }

                        Tab("Profile", systemImage: "person", value: .profile) {
                            ProfileView().environmentObject(authVM)
                        }
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        HomeView().environmentObject(authVM)
                            .tabItem { Label("Home", systemImage: "house") }
                            .tag(AppTab.home)

                        WardrobeView().environmentObject(authVM)
                            .tabItem { Label("Wardrobe", systemImage: "sparkles") }
                            .tag(AppTab.wardrobe)

                        Color.clear
                            .tabItem { Label("Create", systemImage: "wand.and.stars") }
                            .tag(AppTab.create)

                        TravelView().environmentObject(authVM)
                            .tabItem { Label("Travel", systemImage: "airplane") }
                            .tag(AppTab.travel)

                        ProfileView().environmentObject(authVM)
                            .tabItem { Label("Profile", systemImage: "person") }
                            .tag(AppTab.profile)
                    }
                }
            }
            .onChange(of: selectedTab) { newValue in
                if newValue == .create {
                    showCreateOptionsSheet = true
                    selectedTab = lastNonCreateTab
                    return
                }

                lastNonCreateTab = newValue
            }

            CreateOptionsBottomSheet(
                isPresented: $showCreateOptionsSheet,
                onAddClothes: {
                    selectedTab = .wardrobe
                },
                onSelect: { option in
                    switch option {
                    case .planOccasion:
                        selectedTab = .home
                    case .travelCapsule:
                        selectedTab = .travel
                    case .addClothes:
                        break
                    }
                }
            )
        }
        .tabViewStyle(.automatic)
        .tint(.buttonPrimary)
        .modifier(TabBarToolbarBackgroundCompat())
    }
}

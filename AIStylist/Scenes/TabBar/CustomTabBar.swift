//
//  CustomTabBar.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

enum AppTab: Hashable {
    case home
    case wardrobe
    case create
    case travel
    case profile
}

struct TabBarView: View {

    @State private var selectedTab: AppTab = .home

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
        Group {
            if #available(iOS 18.0, *) {
                TabView(selection: $selectedTab) {
                    Tab("Home", systemImage: "house", value: .home) {
                        HomeView()
                    }

                    Tab("Wardrobe", systemImage: "sparkles", value: .wardrobe) {
                        WardrobeView()
                    }

                    Tab("", systemImage: "wand.and.stars", value: .create) {
                        CreateOutfitView()
                    }

                    Tab("Travel", systemImage: "airplane", value: .travel) {
                        TravelView()
                    }

                    Tab("Profile", systemImage: "person", value: .profile) {
                        ProfileView()
                    }
                }
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house") }
                        .tag(AppTab.home)

                    WardrobeView()
                        .tabItem { Label("Wardrobe", systemImage: "sparkles") }
                        .tag(AppTab.wardrobe)

                    CreateOutfitView()
                        .tabItem { Label("", systemImage: "wand.and.stars") }
                        .tag(AppTab.create)

                    TravelView()
                        .tabItem { Label("Travel", systemImage: "airplane") }
                        .tag(AppTab.travel)

                    ProfileView()
                        .tabItem { Label("Profile", systemImage: "person") }
                        .tag(AppTab.profile)
                }
            }
        }
        .tabViewStyle(.automatic)
        .tint(.buttonPrimary)
        .modifier(TabBarToolbarBackgroundCompat())
    }
}

private struct TabBarToolbarBackgroundCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color(.systemBackground), for: .tabBar)
        } else {
            content
        }
    }
}

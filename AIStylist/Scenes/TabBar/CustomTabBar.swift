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
        TabView(selection: $selectedTab) {

            Tab("Home", systemImage: "house", value: .home) {
                HomeView()
            }

            Tab("Wardrobe", systemImage: "sparkles", value: .wardrobe) {
                WardrobeView()
            }

            Tab("Create", systemImage: "plus", value: .create) {
                CreateOutfitView()
            }

            Tab("Travel", systemImage: "airplane", value: .travel) {
                TravelView()
            }

            Tab("Profile", systemImage: "person", value: .profile) {
                ProfileView()
            }
        }
        .tabViewStyle(.automatic)
        .tint(.buttonPrimary)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
    }
}

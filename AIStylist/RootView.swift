//
//  RootView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showCreate = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag(AppTab.home)
            WardrobeView().tag(AppTab.wardrobe)
            TravelView().tag(AppTab.travel)
            ProfileView().tag(AppTab.profile)
        }
        .modifier(HideSystemTabBarCompat())
        .safeAreaInset(edge: .bottom) {
            TabBarView()
        }
        .sheet(isPresented: $showCreate) {
            CreateOutfitView()
        }
    }
}

private struct HideSystemTabBarCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbar(.hidden, for: .tabBar)
        } else {
            content
                .onAppear { UITabBar.appearance().isHidden = true }
                .onDisappear { UITabBar.appearance().isHidden = false }
        }
    }
}

//
//  AIStylistApp.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 5.11.2025.
//

import SwiftUI
import RevenueCat

@main
struct AIStylistApp: App {
    @StateObject private var premium = PremiumManager()
    @StateObject private var auth = AuthViewModel()

    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "test_ObkcNDlMneyeiLCnYKDkaiKCGgg")
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(premium)
                .environmentObject(auth)
                .preferredColorScheme(.light)
                .task {
                    premium.configure()
                    await auth.loadInitialUserIfAvailable()
                }
        }
    }
}

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
        // RevenueCat Configuration
        #if DEBUG
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_QaReAVCDlELAkukKuKhpIHHCBNq")
        #else
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: "appl_QaReAVCDlELAkukKuKhpIHHCBNq")
        #endif
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

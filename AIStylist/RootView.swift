//
//  RootView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI
import RevenueCatUI

struct RootView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var premium: PremiumManager
    @State private var didCheckInitialSession = false

    var body: some View {
        Group {
            if !didCheckInitialSession {
                Color.clear
            } else if authVM.signedInUser != nil {
                TabBarView()
            } else {
                SplashView()
            }
        }
        .onAppear {
            Task {
                await authVM.loadInitialUserIfAvailable()
                await MainActor.run {
                    didCheckInitialSession = true
                }
            }
        }
    }
}

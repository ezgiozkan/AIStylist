//
//  RootView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var didCheckInitialSession = false

    var body: some View {
        Group {
            if !didCheckInitialSession {
                Color.clear
            } else if authVM.signedInUser != nil {
                TabBarView()
                    .environmentObject(authVM)
            } else {
                SplashView()
                    .environmentObject(authVM)
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

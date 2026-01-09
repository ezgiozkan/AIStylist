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
    @State private var didCheckInitialSession = false

    var body: some View {
        Group {
            if !didCheckInitialSession {
                Color.clear
            } else if authVM.signedInUser != nil {
                TabBarView()
                    .presentPaywallIfNeeded(
                        requiredEntitlementIdentifier: "premium",
                        purchaseCompleted: { customerInfo in
                            print("Purchase completed: \(customerInfo.entitlements)")
                        },
                        restoreCompleted: { customerInfo in
                            print("Purchases restored: \(customerInfo.entitlements)")
                        }
                    )
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

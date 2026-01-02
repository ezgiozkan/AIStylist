//
//  PremiumPaywallView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 2.01.2026.
//

import SwiftUI
import Adapty
import AdaptyUI

struct PremiumPaywallView: View {
    @EnvironmentObject var premium: PremiumManager
    @Binding var isPresented: Bool

    @State private var paywallConfig: AdaptyUI.PaywallConfiguration?
    @State private var isLoading = false

    private let placementId = "main_paywall"

    var body: some View {
        Group {
            if let paywallConfig {
                AdaptyPaywallView(
                    paywallConfiguration: paywallConfig,
                    didFinishPurchase: { _, _ in
                        Task {
                            await premium.refreshAccess()
                            if premium.isPremium { isPresented = false }
                        }
                    },
                    didFailPurchase: { _, _ in },
                    didFinishRestore: { _ in
                        Task {
                            await premium.refreshAccess()
                            if premium.isPremium { isPresented = false }
                        }
                    },
                    didFailRestore: { _ in },
                    didFailRendering: { _ in
                        isPresented = false
                    }
                )
            } else {
                ProgressView()
                    .task {
                        if isLoading == false {
                            await loadPaywallConfig()
                        }
                    }
            }
        }
    }

    private func loadPaywallConfig() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let paywall = try await Adapty.getPaywall(placementId: placementId)
            paywallConfig = try await AdaptyUI.getPaywallConfiguration(forPaywall: paywall)
        } catch {
            paywallConfig = nil
        }
    }
}

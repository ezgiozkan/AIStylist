//
//  PremiumManager.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 2.01.2026.
//

import Foundation
import Adapty

@MainActor
final class PremiumManager: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var paywall: AdaptyPaywall?
    @Published var products: [AdaptyPaywallProduct] = []

    private let placementId = "main_paywall"

    func configure() {
        Task {
            await refreshAccess()
            await loadPaywall()
        }
    }

    func refreshAccess() async {
        do {
            let profile = try await Adapty.getProfile()
            isPremium = (profile.accessLevels["premium"]?.isActive ?? false)
        } catch {
            isPremium = false
        }
    }

    func loadPaywall() async {
        do {
            let paywall = try await Adapty.getPaywall(placementId: placementId)
            let products = try await Adapty.getPaywallProducts(paywall: paywall)
            self.paywall = paywall
            self.products = products
        } catch {
            self.paywall = nil
            self.products = []
        }
    }

    func purchaseFirstProduct() async -> Bool {
        guard let product = products.first else { return false }
        do {
            _ = try await Adapty.makePurchase(product: product)
            await refreshAccess()
            return isPremium
        } catch {
            return false
        }
    }

    func restore() async {
        do {
            _ = try await Adapty.restorePurchases()
            await refreshAccess()
        } catch { }
    }
}

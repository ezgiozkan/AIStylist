//
//  PremiumManager.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 2.01.2026.
//

import Foundation
import RevenueCat

@MainActor
final class PremiumManager: ObservableObject {

    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false

    private let entitlementId = "premium"

    func configure() {
        Task {
            await refreshAccess()
        }
    }

    func refreshAccess() async {
        isLoading = true
        do {
            let info = try await Purchases.shared.customerInfo()
            isPremium = info.entitlements[entitlementId]?.isActive == true
        } catch {
            isPremium = false
        }
        isLoading = false
    }

    func restore() async {
        do {
            _ = try await Purchases.shared.restorePurchases()
            await refreshAccess()
        } catch { }
    }
}

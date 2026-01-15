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
    @Published var currentOffering: Offering?

    private let entitlementId = "Ai Stylist Pro"

    @Published var isManuallyPremium: Bool = false {
        didSet {
            if isManuallyPremium {
                isPremium = true
            }
        }
    }
    static let monthlyProductID = "aistylish.monthly"
    static let yearlyProductID = "aistylish.yearly"

    private var customerInfoListenerTask: Task<Void, Never>?

    func configure() {
        customerInfoListenerTask = Task {
            for await customerInfo in Purchases.shared.customerInfoStream {
                await MainActor.run {
                    print("🔍 CustomerInfo stream update:")
                    print("   All entitlement keys (raw): \(Array(customerInfo.entitlements.all.keys))")
                    print("   Active entitlements: \(customerInfo.entitlements.active.keys.joined(separator: ", "))")

                    let possibleKeys = [
                        "Ai Stylist Pro",
                        "ai stylist pro", 
                        "AI Stylist Pro",
                        "ai_stylist_pro",
                        "AiStylistPro",
                        "premium"
                    ]
                    
                    for key in possibleKeys {
                        if let entitlement = customerInfo.entitlements.all[key] {
                            print("   ⚠️ FOUND MATCH: '\(key)' isActive=\(entitlement.isActive)")
                            if entitlement.isActive {
                                self.isPremium = true
                                print("   ✅ Setting isPremium = true with key: '\(key)'")
                                return
                            }
                        }
                    }

                    self.isPremium = customerInfo.entitlements[entitlementId]?.isActive == true
                    print("📱 Premium status updated: \(self.isPremium) (checking: \(entitlementId))")
                    if !self.isPremium && !customerInfo.entitlements.active.isEmpty {
                        print("⚠️ User has active entitlements but not '\(entitlementId)'")
                        print("⚠️ Available: \(Array(customerInfo.entitlements.active.keys))")
                    }
                }
            }
        }
        
        Task {
            await refreshAccess()
            await fetchOfferings()
        }
    }
    
    deinit {
        customerInfoListenerTask?.cancel()
    }

    func refreshAccess() async {
        isLoading = true
        do {
            let info = try await Purchases.shared.customerInfo()
            print("🔍 All entitlements:")
            for (key, entitlement) in info.entitlements.all {
                print("  - \(key): isActive=\(entitlement.isActive), productID=\(entitlement.productIdentifier)")
            }
            isPremium = info.entitlements[entitlementId]?.isActive == true
            print("🔄 Premium status refreshed: \(isPremium) (checking: \(entitlementId))")
            if !isPremium && !info.entitlements.active.isEmpty {
                print("⚠️ Found active entitlements but not matching '\(entitlementId)'")
                print("⚠️ Active entitlements: \(info.entitlements.active.keys.joined(separator: ", "))")
            }
        } catch {
            print("❌ Failed to fetch customer info:", error)
            isPremium = false
        }
        isLoading = false
    }
    
    func fetchOfferings() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            currentOffering = offerings.current
            
            if let offering = offerings.current {
                print("✅ Offerings loaded: \(offering.identifier)")
                print("📦 Available packages: \(offering.availablePackages.map { $0.identifier })")
            }
        } catch {
            print("❌ Failed to fetch offerings:", error)
            currentOffering = nil
        }
    }
    
    func purchase(package: Package) async throws -> CustomerInfo {
        let result = try await Purchases.shared.purchase(package: package)
        await refreshAccess()
        return result.customerInfo
    }

    func restore() async {
        isLoading = true
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            isPremium = customerInfo.entitlements[entitlementId]?.isActive == true
            print("♻️ Purchases restored, premium: \(isPremium)")
        } catch {
            print("❌ Failed to restore purchases:", error)
        }
        isLoading = false
    }

    func debugRefreshFromRevenueCat() async {
        print("🔧 DEBUG: Forcing RevenueCat sync...")
        do {
            try await Purchases.shared.logOut()
            let customerInfo = try await Purchases.shared.customerInfo()
            
            print("🔧 New CustomerInfo:")
            print("   User ID: \(customerInfo.originalAppUserId)")
            for (key, entitlement) in customerInfo.entitlements.all {
                print("   - \(key): isActive=\(entitlement.isActive), productID=\(entitlement.productIdentifier)")
            }
            
            await refreshAccess()
            await fetchOfferings()
        } catch {
            print("❌ Debug refresh failed:", error)
        }
    }
}

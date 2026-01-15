//
//  PremiumDebugView.swift
//  AIStylist
//
//  Debug view for testing RevenueCat integration
//

import SwiftUI
import RevenueCat

struct PremiumDebugView: View {
    @EnvironmentObject private var premium: PremiumManager
    @State private var customerInfo: CustomerInfo?
    @State private var offerings: Offerings?
    
    var body: some View {
        List {
            Section("Premium Status") {
                HStack {
                    Text("Is Premium")
                    Spacer()
                    Text(premium.isPremium ? "✅ YES" : "❌ NO")
                        .foregroundColor(premium.isPremium ? .green : .red)
                }
                
                Toggle("🧪 Manual Premium Override", isOn: $premium.isManuallyPremium)
                    .tint(.orange)

                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Section("Customer Info") {
                if let info = customerInfo {
                    ForEach(Array(info.entitlements.all.keys), id: \.self) { key in
                        if let entitlement = info.entitlements.all[key] {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(key)
                                        .font(.headline)
                                    Spacer()
                                    Text(entitlement.isActive ? "✅ Active" : "❌ Inactive")
                                        .font(.caption)
                                        .foregroundColor(entitlement.isActive ? .green : .gray)
                                }
                                Text("Product: \(entitlement.productIdentifier)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    Text("Loading...")
                }
                
                Button("Refresh Customer Info") {
                    Task {
                        await loadCustomerInfo()
                    }
                }
            }
            
            Section("Offerings") {
                if let offerings = offerings {
                    Text("Current: \(offerings.current?.identifier ?? "nil")")
                    
                    if let current = offerings.current {
                        ForEach(current.availablePackages, id: \.identifier) { package in
                            VStack(alignment: .leading) {
                                Text(package.identifier)
                                    .font(.headline)
                                Text("\(package.storeProduct.localizedPriceString) / \(package.packageType.description)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    Text("Loading...")
                }
                
                Button("Refresh Offerings") {
                    Task {
                        await loadOfferings()
                    }
                }
            }
            
            Section("Actions") {
                Button("Restore Purchases") {
                    Task {
                        await premium.restore()
                        await loadCustomerInfo()
                    }
                }
                
                Button("Clear Cache & Reload") {
                    Task {
                        try? await Purchases.shared.invalidateCustomerInfoCache()
                        await premium.refreshAccess()
                        await loadCustomerInfo()
                    }
                }
                
                Button("🔧 Force RevenueCat Sync", role: .destructive) {
                    Task {
                        await premium.debugRefreshFromRevenueCat()
                        await loadCustomerInfo()
                        await loadOfferings()
                    }
                }
                .foregroundColor(.orange)
            }
            
            Section("Configuration") {
                Text("Entitlement ID: Ai Stylist Pro")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Products:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("• aistylish.monthly")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("• aistylish.yearly")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Premium Debug")
        .onAppear {
            Task {
                await loadCustomerInfo()
                await loadOfferings()
            }
        }
    }
    
    private func loadCustomerInfo() async {
        do {
            customerInfo = try await Purchases.shared.customerInfo()
            print("🔍 Debug - Customer Info loaded:")
            print("   Original User ID: \(customerInfo?.originalAppUserId ?? "nil")")
            print("   Entitlements count: \(customerInfo?.entitlements.all.count ?? 0)")
            
            if let info = customerInfo {
                print("   All entitlements keys: \(Array(info.entitlements.all.keys))")
                print("   Active entitlements keys: \(Array(info.entitlements.active.keys))")
                
                for (key, entitlement) in info.entitlements.all {
                    print("  - \(key): \(entitlement.isActive ? "✅" : "❌") (\(entitlement.productIdentifier))")
                    print("    Identifier: '\(entitlement.identifier)'")
                    print("    Will renew: \(entitlement.willRenew)")
                    print("    Period type: \(entitlement.periodType)")
                }

                print("   Active subscription product IDs: \(info.activeSubscriptions)")
                print("   All purchased product IDs: \(info.allPurchasedProductIdentifiers)")
            }
        } catch {
            print("❌ Debug - Failed to load customer info:", error)
        }
    }
    
    private func loadOfferings() async {
        do {
            offerings = try await Purchases.shared.offerings()
            print("🔍 Debug - Offerings loaded:")
            if let current = offerings?.current {
                print("  Current offering: \(current.identifier)")
                print("  Available packages count: \(current.availablePackages.count)")
                
                for package in current.availablePackages {
                    print("  📦 Package: \(package.identifier)")
                    print("     Product ID: \(package.storeProduct.productIdentifier)")
                    print("     Product type: \(package.packageType)")

                    if let product = package.storeProduct as? SK1Product {
                        print("     SK1 Product")
                    } else if let product = package.storeProduct as? SK2Product {
                        print("     SK2 Product")
                    }
                }
            } else {
                print("  ⚠️ No current offering found!")
            }
            
            print("  All offerings: \(offerings?.all.keys.joined(separator: ", ") ?? "none")")
        } catch {
            print("❌ Debug - Failed to load offerings:", error)
        }
    }
}

extension PackageType {
    var description: String {
        switch self {
        case .monthly: return "Monthly"
        case .annual: return "Yearly"
        case .lifetime: return "Lifetime"
        case .sixMonth: return "6 Months"
        case .threeMonth: return "3 Months"
        case .twoMonth: return "2 Months"
        case .weekly: return "Weekly"
        default: return "Unknown"
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            PremiumDebugView()
                .environmentObject(PremiumManager())
        }
    } else {
        NavigationView {
            PremiumDebugView()
                .environmentObject(PremiumManager())
        }
    }
}

//
//  PremiumFeatureModifier.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 9.01.2026.
//

import SwiftUI
import RevenueCatUI

struct PremiumFeatureModifier: ViewModifier {
    @EnvironmentObject private var premium: PremiumManager
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if premium.isPremium {
                    action()
                }
            }
            .presentPaywallIfNeeded(
                requiredEntitlementIdentifier: "Ai Stylist Pro",
                purchaseCompleted: { customerInfo in
                    print("✅ Purchase completed in feature")
                    action()
                }
            )
    }
}

extension View {
    func premiumFeature(action: @escaping () -> Void) -> some View {
        modifier(PremiumFeatureModifier(action: action))
    }
}

struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.system(size: 10))
            Text("PRO")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            LinearGradient(
                colors: [.purple, .pink],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(8)
    }
}

// MARK: - Manual Paywall Trigger
extension View {
    func showPaywallOnCondition(
        isPresented: Binding<Bool>,
        onPurchase: @escaping () -> Void = {}
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            PaywallView()
                .onPurchaseCompleted { customerInfo in
                    print("✅ Purchase completed: \(customerInfo.entitlements)")
                    onPurchase()
                }
                .onRestoreCompleted { customerInfo in
                    print("✅ Restore completed: \(customerInfo.entitlements)")
                }
        }
    }
}

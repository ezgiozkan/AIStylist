//
//  PremiumPaywallView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 2.01.2026.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct PremiumPaywallView: View {
    @EnvironmentObject var premium: PremiumManager
    @Binding var isPresented: Bool

    var body: some View {
        PaywallView(displayCloseButton: true)
            .onDisappear {
                // Keep local state in sync with the sheet presentation.
                isPresented = false

                // Refresh entitlement state after purchase/restore/close.
                Task { await premium.refreshAccess() }
            }
    }
}

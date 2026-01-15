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
                isPresented = false
                Task { await premium.refreshAccess() }
            }
    }
}

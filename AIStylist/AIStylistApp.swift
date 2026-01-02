//
//  AIStylistApp.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 5.11.2025.
//

import SwiftUI
import Adapty
import AdaptyUI

@main
struct AIStylistApp: App {
    @StateObject private var premium = PremiumManager()

    init() {
        Adapty.activate("public_live_tIDhVRbe.6HBRifMTYi0TMKjUpk3N")
        AdaptyUI.activate()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(premium)
                .preferredColorScheme(.light)
                .task { premium.configure() }
        }
    }
}

//
//  ViewModifier+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct HideSystemTabBarCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbar(.hidden, for: .tabBar)
        } else {
            content
                .onAppear { UITabBar.appearance().isHidden = true }
                .onDisappear { UITabBar.appearance().isHidden = false }
        }
    }
}

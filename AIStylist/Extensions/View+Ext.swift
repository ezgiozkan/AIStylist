//
//  View+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

extension View {
    func hideTabBarOnPush() -> some View {
        modifier(HideTabBarOnPushModifier())
    }
}

private struct HideTabBarOnPushModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbar(.hidden, for: .tabBar)
        } else {
            content
                .background(TabBarVisibilityBridge(hide: true))
        }
    }
}


private struct TabBarVisibilityBridge: UIViewControllerRepresentable {
    let hide: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        Controller(hide: hide)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        (uiViewController as? Controller)?.hide = hide
    }
    
    private final class Controller: UIViewController {
        var hide: Bool
        
        init(hide: Bool) {
            self.hide = hide
            super.init(nibName: nil, bundle: nil)
            view.isUserInteractionEnabled = false
            view.backgroundColor = .clear
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setTabBar(hidden: hide, animated: false)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            setTabBar(hidden: false, animated: false)
        }
        
        private func setTabBar(hidden: Bool, animated: Bool) {
            guard let tabBarController = tabBarController else { return }
            let tabBar = tabBarController.tabBar
            if tabBar.isHidden == hidden { return }
            if animated {
                UIView.animate(withDuration: 0.2) {
                    tabBar.isHidden = hidden
                }
            } else {
                tabBar.isHidden = hidden
            }
        }
    }
}

private struct TabBarToolbarBackgroundCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color(.systemBackground), for: .tabBar)
        } else {
            content
        }
    }
}

//
//  UIApplication+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

extension UIApplication {
    var firstKeyWindowSafeAreaTop: CGFloat {
        (connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.safeAreaInsets.top) ?? 0
    }
}

//
//  ActionCardType.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

enum ActionCardType {
    case occasion
    case travel

    var title: String {
        switch self {
        case .occasion:
            return "Plan an occasion"
        case .travel:
            return "Travel Capsule"
        }
    }

    var subtitle: String {
        switch self {
        case .occasion:
            return "Dress right for the moment"
        case .travel:
            return "Pack efficiently"
        }
    }

    var icon: String {
        switch self {
        case .occasion:
            return "icon_plan"
        case .travel:
            return "icon_travel"
        }
    }

    var accentColor: Color {
        switch self {
        case .occasion:
            return .purple
        case .travel:
            return Color.blue
        }
    }
}

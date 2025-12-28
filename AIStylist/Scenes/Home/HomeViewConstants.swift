//
//  HomeViewConstants.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct HomeViewConstants {
    static let background = Color("homeBackgroundColor")
    static let cardCasualBackground = Color("cardCasualBackground")
    static let cardWorkBackground = Color("cardWorkBackground")
    static let casualTagText = Color("casualTagText")
    static let casualViewLook = Color("casualViewLook")
    static let workTagText = Color("workTagText")
    static let workViewLook = Color("workViewLook")
    static let buttonPrimaryColor = Color("buttonPrimaryColor")
    static let buttonSecondaryColor = Color("buttonSecondaryColor")
    static let primaryText = Color.black.opacity(0.85)
    static let secondaryText = Color.black.opacity(0.55)

    static func weatherSymbolName(for code: Int) -> String {
        switch code {
        case 0:
            return "sun.max"
        case 1, 2:
            return "cloud.sun"
        case 3:
            return "cloud"
        case 45, 48:
            return "cloud.fog"
        case 51, 53, 55, 56, 57:
            return "cloud.drizzle"
        case 61, 63, 65:
            return "cloud.rain"
        case 66, 67:
            return "cloud.sleet"
        case 71, 73, 75, 77, 85, 86:
            return "cloud.snow"
        case 80, 81, 82:
            return "cloud.heavyrain"
        case 95, 96, 99:
            return "cloud.bolt.rain"
        default:
            return "cloud"
        }
    }
}

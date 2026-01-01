//
//  Weather.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

enum Weather: String, CaseIterable, Identifiable {
    case warm
    case cold
    case mixed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .warm: return "Warm"
        case .cold: return "Cold"
        case .mixed: return "Mixed"
        }
    }

    var systemImage: String {
        switch self {
        case .warm: return "sun.max"
        case .cold: return "snowflake"
        case .mixed: return "cloud.sun"
        }
    }

    var apiValue: String {
        switch self {
        case .cold: return "cold"
        case .warm: return "warm"
        case .mixed: return "mixed"
        }
    }
}

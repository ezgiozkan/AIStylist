//
//  CreateOption.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation

enum CreateOption: CaseIterable {
    case planOccasion
    case travelCapsule
    case addClothes

    var title: String {
        switch self {
        case .planOccasion: return "Plan an Occasion"
        case .travelCapsule: return "Travel Capsule"
        case .addClothes: return "Add Clothes to Wardrobe"
        }
    }

    var subtitle: String {
        switch self {
        case .planOccasion: return "Tell us where you’re going — we’ll craft the perfect look."
        case .travelCapsule: return "Build a mix-and-match suitcase for your upcoming trip."
        case .addClothes: return "Upload a photo and we’ll identify items instantly."
        }
    }

    var systemImage: String {
        switch self {
        case .planOccasion: return "calendar"
        case .travelCapsule: return "suitcase"
        case .addClothes: return "tshirt"
        }
    }
}

//
//  RecommendOutfitViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

final class RecommendOutfitViewModel: ObservableObject {

    @Published private(set) var occasions: [OccasionItem] = []
    @Published var selectedOccasionID: String? = nil
    @Published private(set) var isGenerating: Bool = false
    @Published private(set) var generatedOutfit: RecommendOutfitResponse? = nil

    private let recommendService: RecommendOutfitServicing

    init(recommendService: RecommendOutfitServicing = RecommendOutfitService()) {
        self.recommendService = recommendService
        occasions = OccasionConstants.all
        selectedOccasionID = occasions.first?.id
    }

    func select(_ id: String) {
        selectedOccasionID = id
    }

    func generateTapped(token: String, weather: String) {
        let resolvedToken = AuthTokenProvider.token ?? token

        guard let occasion = selectedOccasionID else {
            print("❌ RecommendOutfit NOT STARTED: selectedOccasionID is nil")
            return
        }

        print("🚀 RecommendOutfit START")
        print("Occasion:", occasion)
        print("Weather:", weather)
        print("Token empty:", resolvedToken.isEmpty)

        isGenerating = true
        generatedOutfit = nil

        Task { @MainActor in
            defer { self.isGenerating = false }

            do {
                let result = try await self.recommendService.recommendOutfit(
                    token: resolvedToken,
                    weather: weather,
                    occasion: occasion
                )

                print("✅ RecommendOutfit SUCCESS")
                print("Occasion:", occasion)
                print("Weather:", weather)
                print("Response:", result)

                self.generatedOutfit = result
            } catch {
                print("❌ RecommendOutfit FAILED")
                print("Occasion:", occasion)
                print("Weather:", weather)
                print("Error:", error.localizedDescription)
            }
        }
    }
}

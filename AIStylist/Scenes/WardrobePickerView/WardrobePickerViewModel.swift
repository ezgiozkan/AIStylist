//
//  WardrobePickerViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

@MainActor
final class WardrobePickerViewModel: ObservableObject {
    @Published var selectedCategoryId: String = WardrobeCategoryTab.all.id
    @Published var items: [WardrobeItem] = []
    @Published var selectedIDs: Set<String> = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = WardropeService()

    var filteredItems: [WardrobeItem] {
        if selectedCategoryId == WardrobeCategoryTab.all.id { return items }
        return items.filter { $0.categoryRaw.wardrobeCategoryKey == selectedCategoryId }
    }

    var availableCategories: [WardrobeCategoryTab] {
        let unique = Array(Set(items.map { $0.categoryRaw.wardrobeCategoryKey }))
            .filter { !$0.isEmpty }
            .sorted()

        var tabs: [WardrobeCategoryTab] = [.all]

        for key in unique {
            if let example = items.first(where: { $0.categoryRaw.wardrobeCategoryKey == key }) {
                tabs.append(.init(id: key, title: example.categoryRaw.wardrobeCategoryTitle))
            }
        }

        return tabs
    }

    var selectedItems: [WardrobeItem] {
        items.filter { selectedIDs.contains($0.id) }
    }

    func toggleSelection(for id: String) {
        if selectedIDs.contains(id) { selectedIDs.remove(id) }
        else { selectedIDs.insert(id) }
    }

    func fetchWardrobe() async {
        isLoading = true
        errorMessage = nil

        do {
            guard let token = AuthTokenProvider.token, !token.isEmpty else {
                throw URLError(.userAuthenticationRequired)
            }

            let request = try WardropeEndpoint.wardrobe.urlRequest(bearerToken: token)
            let fetched: [WardrobeItem] = try await service.send(request)

            items = fetched
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}

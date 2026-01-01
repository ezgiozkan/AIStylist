//
//  TravelViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import MapKit

final class TravelViewModel: NSObject, ObservableObject {
    @Published var destination: String = ""
    @Published var selectedCountryName: String? = nil
    @Published var isCountrySheetPresented: Bool = false
    @Published var tripLength: Int = 5
    @Published var selectedWeather: Weather = .warm

    @Published private(set) var isGenerating: Bool = false
    @Published private(set) var generatedTravelPack: RecommendTravelPackResponseDTO? = nil

    var canDecrementTripLength: Bool { tripLength > 1 }

    var destinationDisplayText: String {
        selectedCountryName ?? "Where are you going?"
    }

    var hasSelectedDestination: Bool {
        selectedCountryName != nil
    }

    private let travelPackService: TravelPackServicing

    func decrementTripLength() {
        guard tripLength > 1 else { return }
        tripLength -= 1
    }

    func incrementTripLength() {
        tripLength += 1
    }

    func generateTapped() {
        generateTapped(token: "")
    }

    func generateTapped(token: String) {
        let resolvedToken = AuthTokenProvider.token ?? token
        print("🚀 Travel generateTapped")
        print("Resolved token empty:", resolvedToken.isEmpty)
        let destinationToSend = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Destination (raw):", destination)
        print("Destination (trimmed):", destinationToSend)
        guard !destinationToSend.isEmpty else { return }
        print("Trip length (days):", tripLength)
        print("Weather:", selectedWeather.apiValue)

        isGenerating = true
        generatedTravelPack = nil

        let days = tripLength
        let weatherParam = selectedWeather.apiValue

        Task { @MainActor in
            defer { self.isGenerating = false }

            do {
                print("➡️ TravelPack REQUEST")
                let result = try await self.travelPackService.recommendTravelPack(
                    token: resolvedToken,
                    destination: destinationToSend,
                    days: days,
                    weather: weatherParam
                )
                print("⬅️ TravelPack SUCCESS")
                print("Response:", result)
                self.generatedTravelPack = result
            } catch {
                print("❌ TravelPack FAILED")
                print(error.localizedDescription)
            }
        }
    }

    @Published var destinationQuery: String = ""
    @Published var destinationSuggestions: [String] = []

    private let completer: MKLocalSearchCompleter = {
        let c = MKLocalSearchCompleter()
        c.resultTypes = .address
        return c
    }()

    override init() {
        self.travelPackService = TravelPackService()
        super.init()
        completer.delegate = self
    }

    init(travelPackService: TravelPackServicing) {
        self.travelPackService = travelPackService
        super.init()
        completer.delegate = self
    }

    func updateDestinationQuery(_ text: String) {
        destinationQuery = text
        completer.queryFragment = text
    }

    func openDestinationPicker() {
        isCountrySheetPresented = true
        if destinationQuery.isEmpty {
            completer.queryFragment = " "
        }
    }

    func selectDestination(_ name: String) {
        selectedCountryName = name
        destination = name
        destinationQuery = name
        isCountrySheetPresented = false
    }

    func clearDestination() {
        selectedCountryName = nil
        destination = ""
        destinationQuery = ""
        destinationSuggestions = []
    }
}

extension TravelViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print("📍 Destination suggestions updated:", completer.results.count)
        destinationSuggestions = completer.results
            .map { [$0.title, $0.subtitle].filter { !$0.isEmpty }.joined(separator: ", ") }
            .filter { !$0.isEmpty }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        destinationSuggestions = []
    }
}

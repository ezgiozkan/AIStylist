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

    var canDecrementTripLength: Bool { tripLength > 1 }

    var destinationDisplayText: String {
        selectedCountryName ?? "Where are you going?"
    }

    var hasSelectedDestination: Bool {
        selectedCountryName != nil
    }

    func decrementTripLength() {
        guard tripLength > 1 else { return }
        tripLength -= 1
    }

    func incrementTripLength() {
        tripLength += 1
    }

    func generateTapped() {
        // backend will be connected later
    }

    @Published var destinationQuery: String = ""
    @Published var destinationSuggestions: [String] = []

    private let completer: MKLocalSearchCompleter = {
        let c = MKLocalSearchCompleter()
        c.resultTypes = .address
        return c
    }()

    override init() {
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
        destinationSuggestions = completer.results
            .map { [$0.title, $0.subtitle].filter { !$0.isEmpty }.joined(separator: ", ") }
            .filter { !$0.isEmpty }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        destinationSuggestions = []
    }
}

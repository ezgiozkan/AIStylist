//
//  TravelView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct TravelView: View {

    private let accentColor: Color = HomeViewConstants.buttonPrimaryColor
    @StateObject private var viewModel = TravelViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    header
                        .padding(.top, 18)

                    destinationCard

                    tripLengthCard

                    weatherCard

                    Spacer(minLength: 0)

                    generateButton
                        .padding(.top, 10)
                        .padding(.bottom, 18)
                }
                .padding(.horizontal, 20)
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $viewModel.isCountrySheetPresented) {
            DestinationPickerSheet(
                query: viewModel.destinationQuery,
                suggestions: viewModel.destinationSuggestions,
                onQueryChange: { viewModel.updateDestinationQuery($0) },
                onSelect: { viewModel.selectDestination($0) },
                accentColor: accentColor
            )
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Plan your")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(Color.black)

            Text("travel outfits")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(accentColor)

            Text("Tell us where you’re going. We’ll handle\nthe style.")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.55))
                .lineSpacing(4)
        }
        .padding(.top, 6)
    }

    private var destinationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Destination")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.8))

            HStack(spacing: 10) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(accentColor.opacity(0.9))
                    .frame(width: 22)

                Button(action: {
                    viewModel.openDestinationPicker()
                }) {
                    HStack(spacing: 8) {
                        Text(viewModel.destinationDisplayText)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(viewModel.hasSelectedDestination ? Color.black.opacity(0.8) : Color.black.opacity(0.35))

                        Spacer(minLength: 0)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.black.opacity(0.35))
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
        )
    }

    private var tripLengthCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trip length")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.8))

                Text("Including travel days")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.black.opacity(0.45))
            }

            HStack {
                CircleButton(accentColor: accentColor, systemName: "minus") {
                    viewModel.decrementTripLength()
                }
                .opacity(viewModel.canDecrementTripLength ? 1 : 0.4)
                .disabled(!viewModel.canDecrementTripLength)

                Text("\(viewModel.tripLength)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.black)
                    .frame(minWidth: 28)

                CircleButton(accentColor: accentColor, systemName: "plus", isPrimary: true) {
                    viewModel.incrementTripLength()
                }

                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
        )
    }

    private var weatherCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weather")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.8))

            HStack(spacing: 12) {
                ForEach(Weather.allCases) { item in
                    WeatherPill(
                        accentColor: accentColor,
                        title: item.title,
                        systemImage: item.systemImage,
                        isSelected: viewModel.selectedWeather == item
                    ) {
                        viewModel.selectedWeather = item
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
        )
    }

    private var generateButton: some View {
        Button {
            viewModel.generateTapped()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .bold))

                Text("Generate outfits with AI")
                    .font(.system(size: 17, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(Color.white)
            .background(accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: accentColor.opacity(0.25), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

private struct CircleButton: View {
    let accentColor: Color
    let systemName: String
    var isPrimary: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: { onTap() }) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(isPrimary ? Color.white : Color.black.opacity(0.75))
                .frame(width: 40, height: 40)
                .background(isPrimary ? accentColor : Color.black.opacity(0.06))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

private struct WeatherPill: View {

    let accentColor: Color
    let title: String
    let systemImage: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: { onTap() }) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .semibold))

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .foregroundStyle(isSelected ? accentColor : Color.black.opacity(0.5))
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? accentColor.opacity(0.10) : Color.black.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(isSelected ? accentColor.opacity(0.35) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

private struct DestinationPickerSheet: View {

    let query: String
    let suggestions: [String]
    let onQueryChange: (String) -> Void
    let onSelect: (String) -> Void
    let accentColor: Color

    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    @State private var localQuery: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Search city…", text: $localQuery)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .onChange(of: localQuery) { newValue in
                        onQueryChange(newValue)
                    }

                List {
                    ForEach(suggestions, id: \.self) { name in
                        Button {
                            onSelect(name)
                        } label: {
                            Text(name)
                                .foregroundStyle(Color.black)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Destination", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(accentColor))
        }
        .onAppear {
            localQuery = query
            onQueryChange(query)
        }
    }
}

#if DEBUG
struct TravelView_Previews: PreviewProvider {
    static var previews: some View {
        TravelView()
    }
}
#endif

//
//  WeatherRow.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

var weatherRow: some View {
    HStack(spacing: 10) {
        Image(systemName: "sun.max")
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.purple.opacity(0.75))

        Text(viewModel.weatherText)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(HomeViewConstants.primaryText)

        Spacer()
    }
    .padding(.horizontal, 20)
}

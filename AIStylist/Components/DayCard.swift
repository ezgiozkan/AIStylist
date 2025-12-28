//
//  DayCard.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct DayCard: View {
    let date: Date?

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(String.weekdayTitleTR(for: date))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.35))

            Text(Date.dayNumber(for: date))
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black.opacity(date == nil ? 0.15 : 0.75))

            OutfitPreviewCard(isFilled: Date.shouldShowMockOutfit(for: date))
        }
        .frame(maxWidth: .infinity)
    }
}

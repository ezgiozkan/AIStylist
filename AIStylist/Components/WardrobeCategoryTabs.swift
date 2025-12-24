//
//  WardrobeCategoryTabs.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct WardrobeCategoryTabs: View {
    @Binding var selected: WardrobeCategory
    let categories: [WardrobeCategory]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories) { category in
                    Button {
                        selected = category
                    } label: {
                        Text(category.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selected == category ? .white : .primary)
                            .padding(.horizontal, WardrobeLayout.pillHorizontalPadding)
                            .frame(height: WardrobeLayout.pillHeight)
                            .background(
                                Capsule().fill(selected == category ? Color.buttonPrimary : Color.white)
                            )
                            .overlay(
                                Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

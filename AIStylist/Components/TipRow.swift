//
//  TipRow.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct TipRow: View {

    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 22)

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.primary)

            Spacer()
        }
    }
}

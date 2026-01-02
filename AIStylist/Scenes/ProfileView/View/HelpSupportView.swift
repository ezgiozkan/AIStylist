//
//  HelpSupportView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 1.01.2026.
//

import SwiftUI

 struct HelpSupportView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Help & Support")
                .font(.system(size: 22, weight: .bold))
            Text("Support resources and contact options will be available here.")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

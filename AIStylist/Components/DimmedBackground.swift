//
//  DimmedBackground.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct DimmedBackground: View {
    @Binding var isPresented: Bool

    var body: some View {
        Color.black.opacity(0.25)
            .ignoresSafeArea()
            .onTapGesture { isPresented = false }
    }
}

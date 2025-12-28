//
//  MonthPickerSheet.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct MonthPickerSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    @Binding var displayedMonth: Date

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let safeBottom = proxy.safeAreaInsets.bottom
            let totalHeight = proxy.size.height
            let sheetHeight = max(320 + safeBottom, totalHeight * 0.40)

            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.black.opacity(0.15))
                    .frame(width: 44, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 8)

                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "tr_TR"))
                .frame(maxWidth: .infinity)
                .clipped()

                Button {
                    displayedMonth = Date.startOfMonth(for: selectedDate)
                    isPresented = false
                } label: {
                    Text("Tamam")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.black)
                }
                .padding(.bottom, max(0, safeBottom))
            }
            .background(Color.white)
            .cornerRadius(24)
            .frame(maxWidth: .infinity)
            .frame(height: sheetHeight)
            .offset(y: max(0, dragOffset))
            .position(x: proxy.size.width / 2, y: proxy.size.height - sheetHeight / 2)
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { value in
                        dragOffset = max(0, value.translation.height)
                    }
                    .onEnded { value in
                        if value.translation.height > 120 {
                            isPresented = false
                        }
                        dragOffset = 0
                    }
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

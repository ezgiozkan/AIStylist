//
//  OutfitCalendarView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 24.12.2025.
//

import SwiftUI

struct OutfitCalendarView: View {
    @SwiftUI.Environment(\.dismiss) private var dismiss

    @State private var selectedDate: Date = Date()
    @State private var displayedMonth: Date = Date()
    @State private var weekIndex: Int = 0
    @State private var isMonthPickerPresented: Bool = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, UIApplication.shared.firstKeyWindowSafeAreaTop)

                weekSelector
                    .padding(.top, 14)

                weekGrid
                    .padding(.top, 22)

                Spacer(minLength: 0)
            }

            if isMonthPickerPresented {
                DimmedBackground(isPresented: $isMonthPickerPresented)
                MonthPickerSheet(
                    isPresented: $isMonthPickerPresented,
                    selectedDate: $selectedDate,
                    displayedMonth: $displayedMonth
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isMonthPickerPresented)
        .onAppear {
            displayedMonth = Date.startOfMonth(for: selectedDate)
            weekIndex = Date.weekIndex(for: selectedDate, in: displayedMonth)
        }
        .onChange(of: selectedDate) { newValue in
            displayedMonth = Date.startOfMonth(for: newValue)
            weekIndex = Date.weekIndex(for: newValue, in: displayedMonth)
        }
        .onChange(of: displayedMonth) { _ in
            weekIndex = min(weekIndex, 3)
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }

            Spacer(minLength: 0)

            Button {
                isMonthPickerPresented = true
            } label: {
                HStack(spacing: 6) {
                    Text(String.monthTitleTR(for: displayedMonth))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.85))
                }
                .frame(height: 44)
                .contentShape(Rectangle())
            }

            Spacer(minLength: 0)

            Button {
                isMonthPickerPresented = true
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.black.opacity(0.35))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 0)
    }

    private var weekSelector: some View {
        HStack(spacing: 16) {
            Button {
                weekIndex = max(0, weekIndex - 1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.35))
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .disabled(weekIndex == 0)

            Text("\(weekIndex + 1). Hafta")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black.opacity(0.75))

            Button {
                weekIndex = min(3, weekIndex + 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black.opacity(0.35))
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .disabled(weekIndex >= 3)
        }
    }

    private var weekGrid: some View {
        let week = Date.weekDays(for: displayedMonth, weekIndex: weekIndex)

        return VStack(alignment: .center, spacing: 26) {
            HStack(spacing: 18) {
                ForEach(0..<4, id: \.self) { i in
                    let d = week[safe: i]
                    DayCard(date: d as? Date)
                }
            }

            HStack(spacing: 18) {
                ForEach(4..<7, id: \.self) { i in
                    let d = week[safe: i]
                    DayCard(date: d as? Date)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 22)
    }
}

#Preview {
    OutfitCalendarView()
}

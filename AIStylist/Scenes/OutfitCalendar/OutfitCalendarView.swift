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

                weekSelector
                    .padding(.top, 14)

                weekGrid
                    .padding(.top, 22)

                Spacer(minLength: 0)
            }
            .ignoresSafeArea(edges: .top)

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
            displayedMonth = CalendarHelpers.startOfMonth(for: selectedDate)
            weekIndex = CalendarHelpers.weekIndex(for: selectedDate, in: displayedMonth)
        }
        .onChange(of: selectedDate) { newValue in
            displayedMonth = CalendarHelpers.startOfMonth(for: newValue)
            weekIndex = CalendarHelpers.weekIndex(for: newValue, in: displayedMonth)
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
                    Text(CalendarHelpers.monthTitleTR(for: displayedMonth))
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
        let week = CalendarHelpers.weekDays(for: displayedMonth, weekIndex: weekIndex)

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

private struct DayCard: View {
    let date: Date?

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(CalendarHelpers.weekdayTitleTR(for: date))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.35))

            Text(CalendarHelpers.dayNumber(for: date))
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black.opacity(date == nil ? 0.15 : 0.75))

            OutfitPreviewCard(isFilled: CalendarHelpers.shouldShowMockOutfit(for: date))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct OutfitPreviewCard: View {
    let isFilled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.black.opacity(0.03))

            if isFilled {
                HStack(spacing: 10) {
                    VStack(spacing: 6) {
                        Image(systemName: "tshirt")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black.opacity(0.45))
                        Image(systemName: "shirt")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black.opacity(0.45))
                    }
                    Image(systemName: "figure.walk")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(.black.opacity(0.45))
                }
            }
        }
        .frame(height: 96)
    }
}

private struct DimmedBackground: View {
    @Binding var isPresented: Bool

    var body: some View {
        Color.black.opacity(0.25)
            .ignoresSafeArea()
            .onTapGesture { isPresented = false }
    }
}

private struct MonthPickerSheet: View {
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
                    displayedMonth = CalendarHelpers.startOfMonth(for: selectedDate)
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

private enum CalendarHelpers {
    private static var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }

    static func startOfMonth(for date: Date) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps) ?? date
    }

    static func monthTitleTR(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateFormat = "LLLL yyyy"
        let s = f.string(from: date)
        return s.prefix(1).uppercased(with: f.locale) + s.dropFirst()
    }

    static func weekdayTitleTR(for date: Date?) -> String {
        guard let date else { return "" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateFormat = "EEE"
        let s = f.string(from: date)
        return s.prefix(1).uppercased(with: f.locale) + s.dropFirst()
    }

    static func dayNumber(for date: Date?) -> String {
        guard let date else { return "" }
        return "\(calendar.component(.day, from: date))"
    }

    static func weeks(in month: Date) -> [[Date]] {
        let start = startOfMonth(for: month)
        guard let daysRange = calendar.range(of: .day, in: .month, for: start) else { return [] }

        var weeks: [[Date]] = []
        weeks.reserveCapacity(4)

        for w in 0..<4 {
            let startDay = w * 7 + 1
            let endDay = min(startDay + 6, daysRange.count)
            if startDay > daysRange.count {
                weeks.append([])
                continue
            }

            var arr: [Date] = []
            arr.reserveCapacity(max(0, endDay - startDay + 1))

            for d in startDay...endDay {
                if let date = calendar.date(bySetting: .day, value: d, of: start) {
                    arr.append(date)
                }
            }

            weeks.append(arr)
        }

        return weeks
    }

    static func weekDays(for month: Date, weekIndex: Int) -> [Date?] {
        let start = startOfMonth(for: month)
        guard let daysRange = calendar.range(of: .day, in: .month, for: start) else {
            return Array(repeating: nil, count: 7)
        }

        let clampedWeek = min(max(0, weekIndex), 3)
        let startDay = clampedWeek * 7 + 1

        var result: [Date?] = []
        result.reserveCapacity(7)

        for i in 0..<7 {
            let day = startDay + i
            if day <= daysRange.count, let date = calendar.date(bySetting: .day, value: day, of: start) {
                result.append(date)
            } else {
                result.append(nil)
            }
        }

        return result
    }

    static func weekIndex(for date: Date, in month: Date) -> Int {
        let day = calendar.component(.day, from: date)
        return min(3, max(0, (day - 1) / 7))
    }

    static func shouldShowMockOutfit(for date: Date?) -> Bool {
        guard let date else { return false }
        let day = calendar.component(.day, from: date)
        return day == 1 || day == 7
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

#Preview {
    OutfitCalendarView()
}

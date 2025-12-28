//
//  Date+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation

extension Date {

    private enum Const {
        static let firstWeekday: Int = 2
        static let daysPerWeek: Int = 7
        static let weeksPerMonth: Int = 4
    }

    static var mondayGregorianCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = Const.firstWeekday
        return cal
    }

    static func startOfMonth(for date: Date, calendar: Calendar = Date.mondayGregorianCalendar) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps) ?? date
    }

    static func weekDays(for month: Date, weekIndex: Int, calendar: Calendar = Date.mondayGregorianCalendar) -> [Date?] {
        let start = startOfMonth(for: month, calendar: calendar)

        guard let daysRange = calendar.range(of: .day, in: .month, for: start) else {
            return Array(repeating: nil, count: Const.daysPerWeek)
        }

        let clampedWeek = min(max(0, weekIndex), Const.weeksPerMonth - 1)
        let startDay = clampedWeek * Const.daysPerWeek + 1

        var result: [Date?] = []
        result.reserveCapacity(Const.daysPerWeek)

        for i in 0..<Const.daysPerWeek {
            let day = startDay + i
            if day <= daysRange.count,
               let date = calendar.date(bySetting: .day, value: day, of: start) {
                result.append(date)
            } else {
                result.append(nil)
            }
        }

        return result
    }

    static func dayNumber(for date: Date?, calendar: Calendar = Date.mondayGregorianCalendar) -> String {
        guard let date else { return "" }
        return "\(calendar.component(.day, from: date))"
    }

    static func weeks(in month: Date, calendar: Calendar = Date.mondayGregorianCalendar) -> [[Date]] {
        let start = startOfMonth(for: month, calendar: calendar)
        guard let daysRange = calendar.range(of: .day, in: .month, for: start) else { return [] }

        var weeks: [[Date]] = []
        weeks.reserveCapacity(Const.weeksPerMonth)

        for w in 0..<Const.weeksPerMonth {
            let startDay = w * Const.daysPerWeek + 1
            let endDay = min(startDay + (Const.daysPerWeek - 1), daysRange.count)
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

    static func weekIndex(for date: Date, in month: Date, calendar: Calendar = Date.mondayGregorianCalendar) -> Int {
        let day = calendar.component(.day, from: date)
        return min(Const.weeksPerMonth - 1, max(0, (day - 1) / Const.daysPerWeek))
    }

    static func shouldShowMockOutfit(for date: Date?, calendar: Calendar = Date.mondayGregorianCalendar) -> Bool {
        guard let date else { return false }
        let day = calendar.component(.day, from: date)
        return day == 1 || day == 7
    }
}

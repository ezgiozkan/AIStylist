//
//  String+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import SwiftUI

extension String {
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
}

//
//  Array+Ext.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

//
//  ProfileViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 29.12.2025.
//

import Foundation

final class ProfileViewModel: ObservableObject {

    @Published private(set) var displayName: String = "Profile"
    @Published private(set) var displayEmail: String = "-"
    @Published private(set) var avatarURL: URL? = nil
    @Published private(set) var initials: String = "A"

    func bind(user: AuthUser?) {
        let name = Self.makeDisplayName(user: user)
        displayName = name
        displayEmail = user?.email ?? "-"

        if let s = user?.avatarURL, !s.isEmpty, let u = URL(string: s) {
            avatarURL = u
        } else {
            avatarURL = nil
        }

        initials = Self.makeInitials(from: name)
    }

    private static func makeDisplayName(user: AuthUser?) -> String {
        let full = user?.fullName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let full, !full.isEmpty { return full }

        let email = user?.email ?? ""
        let prefix = email.split(separator: "@").first.map(String.init) ?? ""
        return prefix.isEmpty ? "Profile" : prefix
    }

    private static func makeInitials(from name: String) -> String {
        let parts = name
            .split(separator: " ")
            .map { String($0) }
            .filter { !$0.isEmpty }

        let first = parts.first?.first.map(String.init) ?? "A"
        let second = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + second).uppercased()
    }
}

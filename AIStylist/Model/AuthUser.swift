//
//  AuthUser.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import Auth
import Supabase

struct AuthUser {
    let id: UUID?
    let email: String?
    let fullName: String?
    let avatarURL: String?

    var accessToken: String?
    var refreshToken: String?
}

extension AuthUser {
    init(from user: User) {
        self.id = user.id
        self.email = user.email

        let meta = user.userMetadata

        func stringValue(_ key: String) -> String? {
            guard let raw = meta[key] else { return nil }

            if let s = raw as? String { return s }
            if let url = raw as? URL { return url.absoluteString }
            if let n = raw as? NSNumber { return n.stringValue }

            let described = String(describing: raw)
            return described == "nil" ? nil : described
        }

        let given = stringValue("given_name")
        let family = stringValue("family_name")
        let composed = [given, family].compactMap { $0 }.joined(separator: " ")
        let composedName = composed.isEmpty ? nil : composed

        self.fullName =
            stringValue("full_name") ??
            stringValue("name") ??
            stringValue("display_name") ??
            stringValue("preferred_username") ??
            composedName

        self.avatarURL =
            stringValue("avatar_url") ??
            stringValue("picture")

        self.accessToken = nil
        self.refreshToken = nil
    }

    init(from session: Session) {
        self.init(from: session.user)
        self.accessToken = session.accessToken
        self.refreshToken = session.refreshToken
    }
}

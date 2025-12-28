//
//  SessionStore.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import Supabase

@MainActor
final class SessionStore: ObservableObject {
    @Published var isSignedIn: Bool = false

    private var task: Task<Void, Never>?

    init() {
        isSignedIn = (SupabaseManager.shared.client.auth.currentSession != nil)

        task = Task {
            for await (_, session) in await SupabaseManager.shared.client.auth.authStateChanges {
                isSignedIn = (session != nil)
                if session != nil {
                    await SupabaseManager.shared.client.auth.startAutoRefresh()
                }
            }
        }
    }

    deinit { task?.cancel() }

    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            isSignedIn = false
        } catch {
            print("Sign out error:", error)
        }
    }
}

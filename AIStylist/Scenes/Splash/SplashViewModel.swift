//
//  SplashViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import AuthenticationServices

final class SplashViewModel: ObservableObject {
    @Published private(set) var isSigningIn: Bool = false

    func signInWithGoogle() async {
        await MainActor.run { self.isSigningIn = true }
        defer { Task { @MainActor in self.isSigningIn = false } }

        do {
            _ = try await SupabaseManager.shared.client.auth.signInWithOAuth(
                provider: .google,
                redirectTo: URL(string: "aistyle://login-callback")!
            ) { (session: ASWebAuthenticationSession) in
                session.prefersEphemeralWebBrowserSession = true
            }

            await SupabaseManager.shared.client.auth.startAutoRefresh()
        } catch {
            print("Google sign in error:", error)
        }
    }

    func signInWithApple() async {
        await MainActor.run { self.isSigningIn = true }
        defer { Task { @MainActor in self.isSigningIn = false } }

        do {
            _ = try await SupabaseManager.shared.client.auth.signInWithOAuth(
                provider: .apple,
                redirectTo: URL(string: "aistyle://login-callback")!
            ) { (session: ASWebAuthenticationSession) in
                session.prefersEphemeralWebBrowserSession = true
            }

            await SupabaseManager.shared.client.auth.startAutoRefresh()
        } catch {
            print("Apple sign in error:", error)
        }
    }
}

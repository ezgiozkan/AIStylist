//
//  SplashViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation
import AuthenticationServices

@MainActor
final class SplashViewModel: ObservableObject {
    private let authVM = AuthViewModel()

    func signInWithGoogle() async {
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
        //TODO: signInWithApple
    }
}

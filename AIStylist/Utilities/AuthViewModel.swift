//
//  AuthViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import AuthenticationServices
import Supabase
import UIKit

@MainActor
final class AuthViewModel: ObservableObject {

    @Published private(set) var signedInUser: AuthUser?
    @Published private(set) var accessToken: String?
    @Published private(set) var lastAuthErrorMessage: String?

    private var webAuthSession: ASWebAuthenticationSession?

    func signInWithGoogle() async {
        lastAuthErrorMessage = nil
        accessToken = nil
        do {
            let redirectTo = URL(string: "aistyle://login-callback")!

            let authURL = try await SupabaseManager.shared.client.auth
                .getOAuthSignInURL(provider: .google, redirectTo: redirectTo)

            let session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: "aistyle"
            ) { callbackURL, error in
                defer { self.webAuthSession = nil }

                if let error {
                    print("Google sign in error:", error)
                    self.lastAuthErrorMessage = error.localizedDescription
                    return
                }
                guard let callbackURL else { return }

                Task {
                    do {
                        let authSession = try await SupabaseManager.shared.client.auth.session(from: callbackURL)
                        self.signedInUser = AuthUser(from: authSession)
                        self.accessToken = authSession.accessToken

                    } catch {
                        print("session(from:) error:", error)
                    }
                }
            }

            session.presentationContextProvider = WebAuthPresentationContextProvider.shared
            session.prefersEphemeralWebBrowserSession = false

            self.webAuthSession = session
            _ = session.start()

        } catch {
            print("getOAuthSignInURL error:", error)
            lastAuthErrorMessage = error.localizedDescription
        }
    }

    func loadInitialUserIfAvailable() async {
        if let session = SupabaseManager.shared.client.auth.currentSession {
            signedInUser = AuthUser(from: session)
            accessToken = session.accessToken
        }

        do {
            let freshUser = try await SupabaseManager.shared.client.auth.user()

            let token = SupabaseManager.shared.client.auth.currentSession?.accessToken ?? accessToken
            let refresh = SupabaseManager.shared.client.auth.currentSession?.refreshToken ?? signedInUser?.refreshToken

            signedInUser = AuthUser(
                id: freshUser.id,
                email: freshUser.email,
                fullName: freshUser.userMetadata["full_name"]?.stringValue,
                avatarURL: freshUser.userMetadata["avatar_url"]?.stringValue ?? freshUser.userMetadata["picture"]?.stringValue,
                accessToken: token,
                refreshToken: refresh
            )
        } catch {}
    }
}

final class WebAuthPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = WebAuthPresentationContextProvider()
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

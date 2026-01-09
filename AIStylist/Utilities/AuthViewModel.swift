//
//  AuthViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import AuthenticationServices
import CryptoKit
import Security
import Supabase
import UIKit

@MainActor
final class AuthViewModel: ObservableObject {

    @Published private(set) var signedInUser: AuthUser?
    @Published private(set) var accessToken: String?
    @Published private(set) var lastAuthErrorMessage: String?

    private var webAuthSession: ASWebAuthenticationSession?

    func signInWithApple() async {
        lastAuthErrorMessage = nil
        accessToken = nil
        AuthTokenProvider.token = nil

        do {
            let result = try await AppleSignInCoordinator.authorize()

            let session = try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: result.idToken,
                    nonce: result.nonce
                )
            )

            signedInUser = AuthUser(from: session)
            accessToken = session.accessToken
            AuthTokenProvider.token = session.accessToken
        } catch {
            print("Apple sign in error:", error)
            lastAuthErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func signInWithGoogle() async {
        lastAuthErrorMessage = nil
        accessToken = nil
        AuthTokenProvider.token = nil

        do {
            let redirectTo = URL(string: "aistyle://login-callback")!

            let authURL = try await SupabaseManager.shared.client.auth
                .getOAuthSignInURL(provider: .google, redirectTo: redirectTo)

            let session = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: redirectTo.scheme
            ) { [weak self] callbackURL, error in
                guard let self else { return }
                defer { self.webAuthSession = nil }

                if let error {
                    print("Google sign in error:", error)
                    self.lastAuthErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    return
                }

                guard let callbackURL else {
                    self.lastAuthErrorMessage = "Authentication callback missing."
                    return
                }

                Task { @MainActor in
                    do {
                        let authSession = try await SupabaseManager.shared.client.auth.session(from: callbackURL)
                        self.signedInUser = AuthUser(from: authSession)
                        self.accessToken = authSession.accessToken
                        AuthTokenProvider.token = authSession.accessToken
                    } catch {
                        print("session(from:) error:", error)
                        self.lastAuthErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    }
                }
            }

            session.presentationContextProvider = WebAuthPresentationContextProvider.shared
            session.prefersEphemeralWebBrowserSession = true

            self.webAuthSession = session

            if !session.start() {
                self.webAuthSession = nil
                lastAuthErrorMessage = "Authentication session could not be started."
            }
        } catch {
            print("getOAuthSignInURL error:", error)
            lastAuthErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func signInAsGuest() async {
        lastAuthErrorMessage = nil
        accessToken = nil
        AuthTokenProvider.token = nil

        do {
            let response = try await SupabaseManager.shared.client.auth.signInAnonymously()
            let session = response
            signedInUser = AuthUser(from: session)
            accessToken = session.accessToken
            AuthTokenProvider.token = session.accessToken


        } catch {
            print("Guest sign in error:", error)
            lastAuthErrorMessage = error.localizedDescription
        }
    }

    func loadInitialUserIfAvailable() async {
        if let session = SupabaseManager.shared.client.auth.currentSession {
            signedInUser = AuthUser(from: session)
            accessToken = session.accessToken
            AuthTokenProvider.token = session.accessToken

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
            AuthTokenProvider.token = token

        } catch {}
    }


    @discardableResult
    func deleteAccount() async -> Bool {
        lastAuthErrorMessage = nil

        do {
            _ = try await SupabaseManager.shared.client.functions.invoke("delete-account")
            signedInUser = nil
            accessToken = nil
            AuthTokenProvider.token = nil
            return true
        } catch {
            print("Delete account error:", error)
            lastAuthErrorMessage = error.localizedDescription
            return false
        }
    }

    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            _ = SupabaseManager.shared.client.auth.currentSession
        } catch {
            print("Sign out error:", error)
        }


        signedInUser = nil
        accessToken = nil
        lastAuthErrorMessage = nil
        AuthTokenProvider.token = nil
    }
}

final class WebAuthPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = WebAuthPresentationContextProvider()
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .map { $0.windows }
            .flatMap { $0 }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

private enum AppleSignInError: Error {
    case missingIdentityToken
    case invalidIdentityToken
    case missingNonce
    case canceled
    case unknown
}

private struct AppleSignInResult {
    let idToken: String
    let nonce: String
}

private final class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    private var continuation: CheckedContinuation<AppleSignInResult, Error>?
    private var currentNonce: String?

    static func authorize() async throws -> AppleSignInResult {
        let coordinator = AppleSignInCoordinator()
        return try await coordinator.start()
    }

    private func start() async throws -> AppleSignInResult {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AppleSignInResult, Error>) in
            self.continuation = continuation

            let nonce = Self.randomNonceString()
            self.currentNonce = nonce

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = Self.sha256(nonce)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleSignInError.unknown)
            continuation = nil
            return
        }

        guard let nonce = currentNonce else {
            continuation?.resume(throwing: AppleSignInError.missingNonce)
            continuation = nil
            return
        }

        guard let identityTokenData = appleIDCredential.identityToken else {
            continuation?.resume(throwing: AppleSignInError.missingIdentityToken)
            continuation = nil
            return
        }

        guard let idToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleSignInError.invalidIdentityToken)
            continuation = nil
            return
        }

        continuation?.resume(returning: AppleSignInResult(idToken: idToken, nonce: nonce))
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let asError = error as? ASAuthorizationError, asError.code == .canceled {
            continuation?.resume(throwing: AppleSignInError.canceled)
        } else {
            continuation?.resume(throwing: error)
        }
        continuation = nil
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .map { $0.windows }
            .flatMap { $0 }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    private static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }

    private static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            var randoms = [UInt8](repeating: 0, count: 16)
            let status = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
            if status != errSecSuccess {
                let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                return String(uuid.prefix(length))
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

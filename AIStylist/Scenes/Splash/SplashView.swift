//
//  SplashView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 5.11.2025
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var showContinueWithEmail = false
    @State private var animateExplore = false
    @State private var isSigningIn = false
    
    var body: some View {
        ZStack {
            Image("icon_onboarding")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    if showContinueWithEmail {
                        VStack(spacing: 18) {
                            HStack(spacing: 16) {
                                Button {
                                    Task {
                                        isSigningIn = true
                                        await authVM.signInWithGoogle()
                                        isSigningIn = false
                                    }
                                } label: {
                                    Image("icon_google")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .frame(width: 56, height: 56)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                                }
                                .disabled(isSigningIn)

                                Button {
                                    Task {
                                        isSigningIn = true
                                        await authVM.signInWithApple()
                                        isSigningIn = false
                                    }
                                } label: {
                                    Image(systemName: "applelogo")
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(Color.black)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                                }
                                .disabled(isSigningIn)
                            }

                            Button {
                                Task {
                                    isSigningIn = true
                                    await authVM.signInAsGuest()
                                    isSigningIn = false
                                }
                            } label: {
                                Text("Continue as Guest")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.black)
                                    .clipShape(Capsule())
                            }
                            .disabled(isSigningIn)
                        }
                    } else {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showContinueWithEmail = true
                            }
                        }) {
                            VStack(spacing: 14) {
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                AngularGradient(
                                                    gradient: Gradient(colors: [Color.purple, Color.pink, Color.purple]),
                                                    center: .center
                                                )
                                            )
                                            .rotationEffect(.degrees(animateExplore ? 360 : 0))
                                            .animation(.linear(duration: 2.2).repeatForever(autoreverses: false), value: animateExplore)
                                            .frame(width: 64, height: 64)

                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(0.55), Color.white.opacity(0.05)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                            .frame(width: 64, height: 64)
                                            .opacity(animateExplore ? 0.18 : 0.45)
                                            .scaleEffect(animateExplore ? 1.15 : 0.92)
                                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animateExplore)
                                    }

                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Text("TAP TO EXPLORE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color.black.opacity(0.28))
                                    .tracking(3)
                            }
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 90)
            }
        }
        .onAppear {
            animateExplore = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(AuthViewModel())
    }
}

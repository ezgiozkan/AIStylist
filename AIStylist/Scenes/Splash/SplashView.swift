//
//  SplashView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 5.11.2025
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showContinueWithEmail = false
    @State private var animateExplore = false
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
                        VStack(spacing: 12) {
                            Button {
                                Task { await authVM.signInWithGoogle() }
                            } label: {
                                HStack(spacing: 12) {
                                    Image("icon_google")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)

                                    Text("Continue with Google")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                            }

                            Button {
                                Task {
                                   // await authVM.signInWithApple()
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "applelogo")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)

                                    Text("Continue with Apple")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.black)
                                .clipShape(Capsule())
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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

//
//  SplashView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 5.11.2025
//

import SwiftUI

struct SplashView: View {
    private var totalPages: Int { pages.count }
    @State private var currentPage = 0
    @State private var isHomePresented = false
    @AppStorage("didCompleteOnboarding") private var didCompleteOnboarding = false

    private struct OnboardingCopy {
        let title1: String
        let title2: String
        let subtitle: String
    }

    private let pages: [OnboardingCopy] = [
        .init(
            title1: "We learn your style, body type",
            title2: "and preferences",
            subtitle: "Let our smart mascot analyze your fashion taste to recommend outfits that fit you perfectly."
        ),
        .init(
            title1: "Get daily outfit suggestions",
            title2: "powered by Al",
            subtitle: "Your personal fashion assistant that learns your style and suggests perfect looks every morning."
        ),
        .init(
            title1: "Save looks and plan your",
            title2: "outfits by day",
            subtitle: "Organize your wardrobe digitally and schedule your perfect look for every occasion ahead of time."
        ),
        .init(
            title1: "Your style journey",
            title2: "starts now!",
            subtitle: "Let our friendly AI stylist help you discover outfits that make you feel your best self every day."
        )
    ]

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.93, blue: 0.98),
                    Color(red: 0.90, green: 0.88, blue: 0.96)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                VStack(spacing: 16) {

                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("aiPurple"))

                        Text("STYLE AI")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.85))
                    )
                    .padding(.top, 34)
                    .padding(.bottom, 40)

                    TabView(selection: $currentPage) {
                        ForEach(pages.indices, id: \.self) { index in
                            let page = pages[index]

                            VStack(spacing: 16) {
                                Image("onboarding\(index + 1)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 320)
                                    .padding(.horizontal, 24)
                                    .padding(.top, -24)

                                VStack(spacing: 4) {
                                    Text(page.title1)
                                        .font(.system(size: 26, weight: .semibold))
                                        .foregroundColor(Color.black.opacity(0.85))

                                    Text(page.title2)
                                        .font(.system(size: 26, weight: .semibold))
                                        .foregroundColor(Color("aiPurple"))
                                }

                                Text(page.subtitle)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color.gray.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.top, 4)
                                    .padding(.horizontal, 32)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)

                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            if index == currentPage {
                                Capsule(style: .continuous)
                                    .fill(Color("aiPurple"))
                                    .frame(width: 26, height: 6)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.35))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    .padding(.top, 6)
                }
                Spacer()

                VStack {
                    Button {
                        if currentPage < totalPages - 1 {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentPage += 1
                            }
                        } else {
                            didCompleteOnboarding = true
                            isHomePresented = true
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if currentPage == totalPages - 1 {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14, weight: .semibold))

                                Text("Get Started")
                                    .font(.system(size: 16, weight: .semibold))
                            } else {
                                Text("Continue")
                                    .font(.system(size: 16, weight: .semibold))

                                Image(systemName: "arrow.right")
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color("aiPurple"))
                    )
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .fullScreenCover(isPresented: $isHomePresented) {
                HomeView()
            }
        }
    }
}

#Preview {
    SplashView()
}

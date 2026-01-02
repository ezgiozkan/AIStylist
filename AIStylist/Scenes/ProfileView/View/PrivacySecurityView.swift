//
//  PrivacySecurityView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 1.01.2026.
//

import SwiftUI

struct PrivacySecurityView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Privacy & Security")
                    .font(.system(size: 24, weight: .bold))

                Text("AI Stylist helps you organize your wardrobe and generate outfit suggestions. We aim to keep your data handled responsibly and give you clear control.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)

                sectionTitle("Data you may provide")
                bullet("Wardrobe photos you upload")
                bullet("Basic profile details (name, email)")
                bullet("Inputs you choose (destination, days, occasion, weather)")

                sectionTitle("How it’s used")
                bullet("To analyze uploaded items and suggest outfits or travel packing lists")
                bullet("To personalize your experience inside the app")
                bullet("To troubleshoot issues when you contact support")

                sectionTitle("Security")
                bullet("Authentication is handled via your sign‑in provider")
                bullet("Network requests use secure connections (HTTPS)")
                bullet("You can sign out anytime from Profile")

                sectionTitle("Your choices")
                bullet("You can remove items from your wardrobe from the Wardrobe section")
                bullet("If you want your account removed, contact support from Help & Support")

                Text("For more details, review our Privacy Policy when available in the app or on our website.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                Spacer(minLength: 0)
            }
            .padding(20)
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
        .background(ProfileView.Colors.screenBackground.ignoresSafeArea())
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(ProfileView.Colors.primaryText)
            .padding(.top, 6)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(ProfileView.Colors.purple)
                .frame(width: 6, height: 6)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(ProfileView.Colors.primaryText)
        }
    }
}

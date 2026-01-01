//
//  ProfileView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()

    // MARK: - UI State
    @State private var isLoading = false
    @State private var isLogoutAlertPresented = false

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.sectionSpacing) {
                header
                planCard
                menuCard
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.bottomPadding)
        }
        .background(Colors.screenBackground.ignoresSafeArea())
        .onAppear { viewModel.bind(user: authVM.signedInUser) }
        .onChange(of: authVM.signedInUser?.id) { _ in
            viewModel.bind(user: authVM.signedInUser)
        }
        .alert("Log Out?", isPresented: $isLogoutAlertPresented) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                Task { await authVM.signOut() }
            }
        } message: {
            Text("You will need to sign in again to access your wardrobe and recommendations.")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            avatar

            Text(viewModel.displayName)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Colors.primaryText)

            Text(viewModel.displayEmail)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Colors.linkText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
    }

    private var avatar: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

            Circle()
                .stroke(Color.white, lineWidth: 3)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

            if let url = viewModel.avatarURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        initialsAvatar
                    }
                }
                .clipShape(Circle())
                .padding(3)
            } else {
                initialsAvatar
                    .padding(3)
            }
        }
        .frame(width: Layout.avatarSize, height: Layout.avatarSize)
    }

    private var initialsAvatar: some View {
        ZStack {
            Circle().fill(Colors.avatarBackground)

            Text(viewModel.initials)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(Colors.primaryText)
        }
        .clipShape(Circle())
    }

    // MARK: - Plan Card

    private var planCard: some View {
        Button {
            // TODO: open paywall / premium
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Colors.purpleTint)
                    Image(systemName: "rosette")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Colors.purple)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Free Plan")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Colors.primaryText)

                    Text("Upgrade to unlock premium\nfeatures")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Colors.secondaryText)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Colors.chevron)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                    .fill(Color.white)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Menu Card

    private var menuCard: some View {
        VStack(spacing: 0) {

            ProfileMenuRow(
                iconSystemName: "lock.fill",
                iconBackground: Colors.grayIconBackground,
                iconForeground: Colors.grayIconForeground,
                title: "Privacy & Security",
                isDestructive: false
            ) {
                // TODO: navigate to privacy
            }

            divider

            ProfileMenuRow(
                iconSystemName: "questionmark.circle.fill",
                iconBackground: Colors.grayIconBackground,
                iconForeground: Colors.grayIconForeground,
                title: "Help & Support",
                isDestructive: false
            ) {
                // TODO: navigate to help
            }

            divider

            ProfileMenuRow(
                iconSystemName: "message.fill",
                iconBackground: Colors.grayIconBackground,
                iconForeground: Colors.grayIconForeground,
                title: "Feedback",
                isDestructive: false
            ) {
                // TODO: navigate to feedback
            }

            divider

            ProfileMenuRow(
                iconSystemName: "rectangle.portrait.and.arrow.right.fill",
                iconBackground: Colors.redTint,
                iconForeground: Colors.red,
                title: "Log Out",
                isDestructive: true
            ) {
                isLogoutAlertPresented = true
            }
        }
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(Color.white)
        )
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
    }

    private var divider: some View {
        Rectangle()
            .fill(Colors.separator)
            .frame(height: 1)
            .padding(.leading, Layout.dividerLeading)
    }
}

// MARK: - Row

private struct ProfileMenuRow: View {
    let iconSystemName: String
    let iconBackground: Color
    let iconForeground: Color
    let title: String
    let isDestructive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(iconBackground)
                    Image(systemName: iconSystemName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(iconForeground)
                }
                .frame(width: 40, height: 40)

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isDestructive ? ProfileView.Colors.red : ProfileView.Colors.primaryText)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ProfileView.Colors.chevron)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Layout + Colors

private extension ProfileView {
    enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 26
        static let bottomPadding: CGFloat = 28

        static let sectionSpacing: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20

        static let avatarSize: CGFloat = 104
        static let dividerLeading: CGFloat = 70
    }

    enum Colors {
        static let screenBackground = Color(red: 0.97, green: 0.97, blue: 0.98)

        static let primaryText = Color(red: 0.10, green: 0.10, blue: 0.13)
        static let secondaryText = Color(red: 0.45, green: 0.45, blue: 0.52)
        static let linkText = Color(red: 0.44, green: 0.38, blue: 0.74)

        static let separator = Color.black.opacity(0.06)
        static let chevron = Color.black.opacity(0.25)

        static let purple = Color(red: 0.44, green: 0.38, blue: 0.74)
        static let purpleTint = Color(red: 0.92, green: 0.90, blue: 0.98)

        static let grayIconBackground = Color.black.opacity(0.05)
        static let grayIconForeground = Color.black.opacity(0.55)

        static let red = Color(red: 0.89, green: 0.22, blue: 0.24)
        static let redTint = Color(red: 1.0, green: 0.92, blue: 0.92)

        static let avatarBackground = Color(red: 0.92, green: 0.90, blue: 0.98)
    }
}

#Preview {
    ProfileView()
}

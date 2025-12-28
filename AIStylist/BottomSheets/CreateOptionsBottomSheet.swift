//
//  CreateOptionsBottomSheet.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI
import UIKit

struct CreateOptionsBottomSheet: View {
    @Binding var isPresented: Bool
    let onAddClothes: () -> Void
    let onSelect: (CreateOption) -> Void

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {

            Color.black.opacity(isPresented ? 0.28 : 0)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
                .animation(.easeOut(duration: 0.18), value: isPresented)

            if isPresented {
                sheet
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.28, dampingFraction: 0.92), value: isPresented)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var sheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.black.opacity(0.12))
                .frame(width: 44, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {
                Text("Create")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Choose what you want to build today.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 18)

            VStack(spacing: 14) {
                ForEach(CreateOption.allCases, id: \.self) { option in
                    CreateOptionRow(option: option) {
                        if option == .addClothes {
                            dismiss()
                            onAddClothes()
                        } else {
                            onSelect(option)
                            dismiss()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(TopRoundedCorner(radius: 28))
        .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: -2)
        .offset(y: max(0, dragOffset))
        .gesture(
            DragGesture(minimumDistance: 2)
                .onChanged { value in
                    dragOffset = max(0, value.translation.height)
                }
                .onEnded { value in
                    let shouldDismiss = value.translation.height > 110 || value.predictedEndTranslation.height > 140
                    if shouldDismiss {
                        dismiss()
                    } else {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.92)) {
                            dragOffset = 0
                        }
                    }
                }
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.92)) {
            dragOffset = 0
            isPresented = false
        }
    }
}

struct CreateOptionRow: View {
    let option: CreateOption
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: option.systemImage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.purple)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(option.subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.secondary.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TopRoundedCorner: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

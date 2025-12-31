//
//  CanvasSticker.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct CanvasSticker: View {
    @Binding var item: CanvasItem
    let isActive: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    @State private var startOffset: CGSize = .zero
    @State private var startScale: CGFloat = 1
    @State private var startRotation: Angle = .zero

    @State private var isDragging = false
    @State private var isScaling = false
    @State private var isRotating = false

    var body: some View {
        Image(uiImage: item.image)
            .resizable()
            .scaledToFit()
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isActive ? Color.black.opacity(0.18) : .clear, lineWidth: 1)
            )
            .frame(width: 170, height: 170)
            .overlay(alignment: .topTrailing) {
                if isActive {
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.75))
                            .background(Color.clear.clipShape(Circle()))
                    }
                    .offset(x: 8, y: -8)
                }
            }
            .offset(item.offset)
            .scaleEffect(item.scale)
            .rotationEffect(item.rotation)
            .zIndex(item.zIndex)
            .onTapGesture { onTap() }
            .gesture(dragGesture.simultaneously(with: scaleGesture).simultaneously(with: rotateGesture))
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { v in
                if !isDragging {
                    startOffset = item.offset
                    isDragging = true
                }

                item.offset = CGSize(
                    width: startOffset.width + v.translation.width,
                    height: startOffset.height + v.translation.height
                )
            }
            .onEnded { _ in
                isDragging = false
                startOffset = item.offset
            }
    }

    private var scaleGesture: some Gesture {
        MagnificationGesture()
            .onChanged { v in
                if !isScaling {
                    startScale = item.scale
                    isScaling = true
                }

                item.scale = max(0.5, min(2.5, startScale * v))
            }
            .onEnded { _ in
                isScaling = false
                startScale = item.scale
            }
    }

    private var rotateGesture: some Gesture {
        RotationGesture()
            .onChanged { v in
                if !isRotating {
                    startRotation = item.rotation
                    isRotating = true
                }

                item.rotation = startRotation + v
            }
            .onEnded { _ in
                isRotating = false
                startRotation = item.rotation
            }
    }
}

//
//  OutfitCanvasView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI

struct OutfitCanvasView: View {
    let items: [WardrobeItem]

    @SwiftUI.Environment(\.dismiss) private var dismiss
    @State private var canvasItems: [CanvasItem] = []
    @State private var activeId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            header

            GeometryReader { geo in
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)

                    ZStack {
                        ForEach(canvasItems) { item in
                            CanvasSticker(
                                item: binding(for: item.id),
                                isActive: activeId == item.id,
                                onTap: {
                                    activeId = item.id
                                    bringToFront(item.id)
                                },
                                onDelete: {
                                    delete(item.id)
                                }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(white: 0.95))
            }

            toolbar
        }
        .onAppear {
            canvasItems = items.enumerated().map { idx, w in
                CanvasItem(
                    id: UUID(uuidString: w.id) ?? UUID(),
                    image: UIImage(),
                    offset: CGSize(width: (idx % 2 == 0 ? -60 : 60), height: CGFloat(idx) * 20),
                    scale: 1,
                    rotation: .zero,
                    zIndex: Double(idx)
                )
            }
            Task { await loadCanvasImages() }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text("11 Ara Per")
                .font(.system(size: 17, weight: .semibold))

            Spacer()

            Button("İleri") { }
                .font(.system(size: 15, weight: .semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.85))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color(white: 0.95))
    }

    private var toolbar: some View {
        HStack(spacing: 24) {
            Button { } label: { Image(systemName: "square.2.layers.3d") }
            Button { } label: { Image(systemName: "photo") }
            Button { } label: { Image(systemName: "textformat") }
            Button { } label: { Image(systemName: "face.smiling") }
            Button { } label: { Image(systemName: "trash") }
        }
        .font(.system(size: 20, weight: .semibold))
        .foregroundStyle(.black.opacity(0.85))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    private func loadCanvasImages() async {
        for (idx, w) in items.enumerated() {
            guard idx < canvasItems.count, let url = w.remoteURL else { continue }
            if let image = await fetchImage(url: url) {
                await MainActor.run {
                    if idx < canvasItems.count {
                        canvasItems[idx].image = image
                    }
                }
            }
        }
    }

    private func fetchImage(url: URL) async -> UIImage? {
        do {
            let (data, resp) = try await URLSession.shared.data(from: url)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return nil }
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

    private func binding(for id: UUID) -> Binding<CanvasItem> {
        guard let idx = canvasItems.firstIndex(where: { $0.id == id }) else {
            return .constant(CanvasItem(id: id, image: UIImage()))
        }
        return $canvasItems[idx]
    }

    private func bringToFront(_ id: UUID) {
        let maxZ = (canvasItems.map(\.zIndex).max() ?? 0) + 1
        if let idx = canvasItems.firstIndex(where: { $0.id == id }) {
            canvasItems[idx].zIndex = maxZ
        }
    }

    private func delete(_ id: UUID) {
        canvasItems.removeAll { $0.id == id }
        if activeId == id { activeId = nil }
    }
}

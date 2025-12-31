//
//  OutfitCanvasView.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import SwiftUI
import UIKit

struct OutfitCanvasView: View {
    let items: [WardrobeItem]
    let dayKey: String

    @SwiftUI.Environment(\.dismiss) private var dismiss
    @State private var canvasItems: [CanvasItem] = []
    @State private var activeId: UUID?
    @State private var canvasSize: CGSize = .zero
    @State private var isSaving: Bool = false

    private enum Constants {
        static let canvasCornerRadius: CGFloat = 24
        static let canvasOuterPadding: CGFloat = 20
        static let maxCanvasSide: CGFloat = 520
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            GeometryReader { geo in
                let size = geo.size
                let available = max(0, min(size.width, size.height) - (Constants.canvasOuterPadding * 2))
                let side = min(available, Constants.maxCanvasSide)

                ZStack {
                    Color.pickerGray

                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.canvasCornerRadius, style: .continuous)
                            .fill(Color.white)

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
                    .frame(width: side, height: side)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.canvasCornerRadius, style: .continuous))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .onAppear {
                    canvasSize = CGSize(width: side, height: side)
                }
                .onChange(of: side) { newValue in
                    canvasSize = CGSize(width: newValue, height: newValue)
                }
            }
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

            Text(todayTitle)
                .font(.system(size: 17, weight: .semibold))

            Spacer()

            Button(isSaving ? "Saving…" : "Save") {
                Task { await saveAndClose() }
            }
            .disabled(isSaving)
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
        .background(Color.pickerGray)
    }

    private var todayTitle: String {
        let inFormatter = DateFormatter()
        inFormatter.calendar = Calendar(identifier: .gregorian)
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inFormatter.dateFormat = "yyyy-MM-dd"

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "tr_TR")
        outFormatter.dateFormat = "d MMM EEE"

        if let date = inFormatter.date(from: dayKey) {
            return outFormatter.string(from: date)
        }
        return outFormatter.string(from: Date())
    }

    private var canvasViewForExport: some View {
        ZStack {
            Color.clear

            ZStack {
                RoundedRectangle(cornerRadius: Constants.canvasCornerRadius, style: .continuous)
                    .fill(Color.white)

                ZStack {
                    ForEach(canvasItems) { item in
                        CanvasSticker(
                            item: binding(for: item.id),
                            isActive: false,
                            onTap: { },
                            onDelete: { }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.canvasCornerRadius, style: .continuous))
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .background(Color.clear)
    }

    private func saveAndClose() async {
        guard !isSaving else { return }
        isSaving = true

        let image = snapshot(view: canvasViewForExport, size: canvasSize)
        if let image {
            do {
                try saveCanvasImage(image)
            } catch {
                print("[Canvas] Save failed:", error)
            }
        } else {
            print("[Canvas] Snapshot failed")
        }

        isSaving = false
        NotificationCenter.default.post(name: .outfitCanvasDidSave, object: nil)
        dismiss()
    }

    private func saveCanvasImage(_ image: UIImage) throws {
        guard let data = image.pngData() else {
            throw NSError(domain: "OutfitCanvas", code: -1, userInfo: [NSLocalizedDescriptionKey: "PNG conversion failed"])
        }

        let fm = FileManager.default
        let base = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("outfits", isDirectory: true)

        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        let fileName = "\(dayKey).png"
        let fileURL = dir.appendingPathComponent(fileName)

        try data.write(to: fileURL, options: [.atomic])

        UserDefaults.standard.set(fileName, forKey: "outfit.canvas.\(dayKey)")
        print("[Canvas] Saved:", fileURL.path)
    }

    private func snapshot<V: View>(view: V, size: CGSize) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }

        let controller = UIHostingController(rootView: view)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        controller.view.isOpaque = false
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        format.scale = UIScreen.main.scale

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
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

extension Notification.Name {
    static let outfitCanvasDidSave = Notification.Name("outfit.canvas.didSave")
}

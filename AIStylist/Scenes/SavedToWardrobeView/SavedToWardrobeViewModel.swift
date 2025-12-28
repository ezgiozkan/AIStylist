//
//  SavedToWardrobeViewModel.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//

import Foundation

final class SavedToWardrobeViewModel: ObservableObject {
    
    let response: UploadClothingResponse

    init(response: UploadClothingResponse) {
        self.response = response
    }

    var titleText: String { SavedToWardrobeConstants.title }
    var subtitleText: String { SavedToWardrobeConstants.subtitle }
    var primaryCTAText: String { SavedToWardrobeConstants.primaryCTA }
    var secondaryCTAText: String { SavedToWardrobeConstants.secondaryCTA }

    // MARK: - Preview (best-effort mapping)

    var itemTitle: String {
        // Prefer server-provided display fields if present.
      //  if let title = response.item_name, !title.isEmpty { return title }
      //  if let title = response.name, !title.isEmpty { return title }
        return "New Item"
    }

    var itemSubtitle: String {
     //   if let subtitle = response.collection, !subtitle.isEmpty { return subtitle }
     //   if let subtitle = response.status, !subtitle.isEmpty { return subtitle }
        return ""
    }

    var itemImageURLString: String? {
      //  if let url = response.image_url, !url.isEmpty { return url }
      //  if let url = response.imageUrl, !url.isEmpty { return url }
        return nil
    }
}

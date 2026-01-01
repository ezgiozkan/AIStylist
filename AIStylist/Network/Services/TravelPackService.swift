//
//  TravelPackService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 31.12.2025.
//

import Foundation

protocol TravelPackServicing {
    func recommendTravelPack(token: String, destination: String, days: Int, weather: String) async throws -> RecommendTravelPackResponseDTO
}

final class TravelPackService: TravelPackServicing {
    private enum Constants {
        static let baseURLString = "https://ai-stylist-production.up.railway.app"
        static let path = "recommend-travel-pack"
    }
    func recommendTravelPack(token: String, destination: String, days: Int, weather: String) async throws -> RecommendTravelPackResponseDTO {
        let baseURL = URL(string: Constants.baseURLString)!
        let url = baseURL.appendingPathComponent(Constants.path)

        print("➡️ TravelPack SERVICE REQUEST")
        print("URL:", url.absoluteString)
        print("Destination:", destination)
        print("Days:", days)
        print("Weather:", weather)
        print("Token empty:", token.isEmpty)

        let body = RecommendTravelPackRequest(destination: destination, days: days, weather: weather)
        let request = try URLRequest.aiStylistPOST(url: url, body: body, bearerToken: token)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("⬅️ TravelPack SERVICE HTTP Status:", http.statusCode)
        }

        print("⬅️ TravelPack SERVICE raw response:")
        print(String(data: data, encoding: .utf8) ?? "nil")

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }

        do {
            let dto = try JSONDecoder().decode(RecommendTravelPackResponseDTO.self, from: data)
            print("✅ TravelPack SERVICE DTO Decode SUCCESS")

            let mappedItems: [RecommendTravelPackItemDTO] = dto.items_to_pack.map { item in
                RecommendTravelPackItemDTO(
                    id: item.id,
                    category: item.category,
                    color: item.color,
                    image_url: item.image_url,
                    season: item.season,
                    formality: item.formality,
                    description: item.description,
                    status: item.status
                )
            }

            return RecommendTravelPackResponseDTO(
                pack_name: dto.pack_name,
                items_to_pack: mappedItems,
                outfit_combinations: dto.outfit_combinations,
                reasoning: dto.reasoning
            )
        } catch {
            print("❌ TravelPack SERVICE Decode FAILED")
            print(error)
            throw error
        }
    }
}

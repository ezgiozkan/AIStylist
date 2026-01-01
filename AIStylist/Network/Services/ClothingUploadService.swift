//
//  ClothingUploadService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import Foundation
import Alamofire

protocol ClothingUploadServicing {
    func uploadClothing(pngData: Data, accessToken: String?) async throws -> UploadClothingResponse
}

final class ClothingUploadService: ClothingUploadServicing {
    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }

    func uploadClothing(pngData: Data, accessToken: String?) async throws -> UploadClothingResponse {
        let url = ClothingUploadEndpoint.baseURL.appendingPathComponent("upload-clothing")

        print("➡️ UploadClothing REQUEST")
        print("URL:", url.absoluteString)
        print("PNG size (bytes):", pngData.count)
        print("Token empty:", accessToken?.isEmpty ?? true)

        let dataResponse = await session
            .upload(
                multipartFormData: { formData in
                    print("📦 Building multipart form data")

                    formData.append(
                        pngData,
                        withName: "file",
                        fileName: "image.png",
                        mimeType: "image/png"
                    )
                },
                to: url,
                method: .post,
                headers: {
                    var h: HTTPHeaders = ["accept": "application/json"]
                    if let token = accessToken, !token.isEmpty {
                        h.add(.authorization(bearerToken: token))
                    }
                    return h
                }()
            )
            .serializingData()
            .response

        if let http = dataResponse.response {
            print("⬅️ UploadClothing HTTP Status:", http.statusCode)
        }

        if let rawData = dataResponse.data {
            print("⬅️ UploadClothing raw response:")
            print(String(data: rawData, encoding: .utf8) ?? "nil")
        }

        if let statusCode = dataResponse.response?.statusCode, !(200...299).contains(statusCode) {
            print("❌ UploadClothing FAILED with HTTP", statusCode)
            throw NetworkError.http(status: statusCode, data: dataResponse.data ?? Data())
        }

        switch dataResponse.result {
        case .success(let data):
            print("✅ UploadClothing SUCCESS")
            return try decoder.decode(UploadClothingResponse.self, from: data)

        case .failure(let error):
            print("❌ UploadClothing TRANSPORT ERROR")
            print(error.localizedDescription)

            if let statusCode = dataResponse.response?.statusCode {
                throw NetworkError.http(status: statusCode, data: dataResponse.data ?? Data())
            }
            throw NetworkError.transport(error)
        }
    }
}

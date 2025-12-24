//
//  ClothingUploadService.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 22.12.2025.
//

import Foundation
import Alamofire

protocol ClothingUploadServicing {
    func uploadClothing(pngData: Data) async throws -> UploadClothingResponse
}

final class ClothingUploadService: ClothingUploadServicing {
    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }

    func uploadClothing(pngData: Data) async throws -> UploadClothingResponse {
        let url = ClothingUploadEndpoint.baseURL.appendingPathComponent("upload-clothing")

        let dataResponse = await session
            .upload(
                multipartFormData: { formData in
                    formData.append(
                        pngData,
                        withName: "file",
                        fileName: "image.png",
                        mimeType: "image/png"
                    )
                },
                to: url,
                method: .post,
                headers: ["accept": "application/json"]
            )
            .validate(statusCode: 200...299)
            .serializingData()
            .response

        if let statusCode = dataResponse.response?.statusCode, !(200...299).contains(statusCode) {
            throw NetworkError.http(status: statusCode, data: dataResponse.data ?? Data())
        }

        switch dataResponse.result {
        case .success(let data):
            do {
                return try decoder.decode(UploadClothingResponse.self, from: data)
            } catch {
                let body = String(data: data, encoding: .utf8) ?? ""
                throw NetworkError.decoding(NSError(domain: "Decoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(error.localizedDescription)\(body.isEmpty ? "" : " | body: \(body)")"]))
            }
        case .failure(let error):
            throw NetworkError.transport(error)
        }
    }
}

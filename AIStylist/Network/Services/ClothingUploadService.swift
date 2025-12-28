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

    private enum DebugConfig {
        static let printFullToken = false
        static let tokenPreviewCount = 24
    }

    private func debugRequest(url: URL, accessToken: String?, pngData: Data) {
        #if DEBUG
        print("\n[UploadService] ===== REQUEST DEBUG =====")
        print("[UploadService] URL:", url.absoluteString)
        print("[UploadService] Method: POST")
        print("[UploadService] Multipart:")
        print("  field: file")
        print("  filename: image.png")
        print("  mimeType: image/png")
        print("  fileSize:", pngData.count, "bytes")

        var headers: [String: String] = [
            "accept": "application/json"
        ]

        if let token = accessToken, !token.isEmpty {
            if DebugConfig.printFullToken {
                headers["Authorization"] = "Bearer \(token)"
            } else {
                let preview = String(token.prefix(DebugConfig.tokenPreviewCount))
                headers["Authorization"] = "Bearer \(preview)…"
            }
        } else {
            headers["Authorization"] = "<missing>"
        }

        print("[UploadService] Headers:")
        headers.sorted(by: { $0.key.lowercased() < $1.key.lowercased() }).forEach { key, value in
            print("  \(key): \(value)")
        }

        let curlToken = "<ACCESS_TOKEN>"
        let curl = "curl -X 'POST' \\\n  '\(url.absoluteString)' \\\n  -H 'accept: application/json' \\\n  -H 'Authorization: Bearer \(curlToken)' \\\n  -H 'Content-Type: multipart/form-data' \\\n  -F 'file=@image.png;type=image/png'"

        print("[UploadService] curl (paste token yourself):\n\(curl)")
        print("[UploadService] ===== END REQUEST DEBUG =====\n")
        #endif
    }

    init(session: Session = .default, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }

    func uploadClothing(pngData: Data, accessToken: String?) async throws -> UploadClothingResponse {
        let url = ClothingUploadEndpoint.baseURL.appendingPathComponent("upload-clothing")

        debugRequest(url: url, accessToken: accessToken, pngData: pngData)

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

        #if DEBUG
        if let status = dataResponse.response?.statusCode {
            let body = String(data: dataResponse.data ?? Data(), encoding: .utf8) ?? "<non-utf8>"
            let trimmed = body.count > 1200 ? String(body.prefix(1200)) + "…" : body
            print("[UploadService] status:", status)
            print("[UploadService] body:", trimmed)
        }
        #endif

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
            if let statusCode = dataResponse.response?.statusCode {
                throw NetworkError.http(status: statusCode, data: dataResponse.data ?? Data())
            }
            throw NetworkError.transport(error)
        }
    }
}

//
//  HTTPClient.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 21.12.2025.
//

import Foundation
import Alamofire

protocol ApiClient {
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
    func send<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T
}

final class AlamofireHTTPClient: ApiClient {
    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        do {
            let request = try RequestBuilder.build(endpoint)
            return try await send(request, as: T.self)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.transport(error)
        }
    }

    func send<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        let dataResponse = await session
            .request(request)
            .validate(statusCode: 200...299)
            .serializingDecodable(T.self, decoder: decoder)
            .response

        if let statusCode = dataResponse.response?.statusCode, !(200...299).contains(statusCode) {
            throw NetworkError.http(status: statusCode, data: dataResponse.data ?? Data())
        }

        switch dataResponse.result {
        case .success(let value):
            return value
        case .failure(let error):
            if case .responseSerializationFailed(let reason) = error,
               case .decodingFailed(let underlying) = reason {
                throw NetworkError.decoding(underlying)
            }
            throw NetworkError.transport(error)
        }
    }
}

final class URLSessionHTTPClient: ApiClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        do {
            let request = try RequestBuilder.build(endpoint)
            return try await send(request, as: T.self)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.transport(error)
        }
    }

    func send<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            guard (200...299).contains(http.statusCode) else {
                throw NetworkError.http(status: http.statusCode, data: data)
            }
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.transport(error)
        }
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
}

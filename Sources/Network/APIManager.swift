//
//  APIManager.swift
//  Core
//
//  Created by Ricardo Bailoni on 03/06/24.
//

import Foundation
import Combine

public final class APIManager {
    typealias NetworkResponse = (data: Data, response: URLResponse)
    typealias Failure = APIError
    
    public static let shared = APIManager()
    private init() { }
    
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cancellable = Set<AnyCancellable>()
    
    public func getData<D: Decodable>(from endpoint: EndPointProtocol, completion: @escaping (Result<D, APIError>) -> Void) {
        guard let request = try? createRequest(from: endpoint) else {
            completion(.failure(.request))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.reponse(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.statusCode(response)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let resultData = try JSONDecoder().decode(D.self, from: data)
                completion(.success(resultData))
            } catch {
                completion(.failure(.decoding))
            }
        }.resume()
    }
    
    public func getData<D: Decodable>(from endpoint: EndPointProtocol) -> AnyPublisher<D, Error> {
        guard let request = try? createRequest(from: endpoint) else {
            return Fail(error: APIError.request).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw APIError.statusCode(response)
                }
                return data
            }
            .decode(type: D.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    public func getData<D: Decodable>(from endpoint: EndPointProtocol) async throws -> D {
        let request = try createRequest(from: endpoint)
        let response: NetworkResponse = try await session.data(for: request)
        return try decoder.decode(D.self, from: response.data)
    }
    
    
    public func sendData<D: Decodable, E: Encodable>(from endpoint: EndPointProtocol, with body: E) async throws -> D {
        let request = try createRequest(from: endpoint)
        let data = try encoder.encode(body)
        let response: NetworkResponse = try await session.upload(for: request, from: data)
        return try decoder.decode(D.self, from: response.data)
    }
}

private extension APIManager {
    func createRequest(from endpoint: EndPointProtocol) throws -> URLRequest {
        guard let urlPath = URL(string: endpoint.baseURL.appending(endpoint.path)),
              var urlComponents = URLComponents(string: urlPath.path)
        else {
            throw APIError.path
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = endpoint.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
}

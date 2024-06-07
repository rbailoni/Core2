//
//  EndPointProtocol.swift
//  Core
//
//  Created by Ricardo Bailoni on 03/06/24.
//

import Foundation

public protocol EndPointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: Method { get }
    var parameters: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

public enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

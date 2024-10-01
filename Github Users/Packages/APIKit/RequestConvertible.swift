//
//  File.swift
//  
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation

public protocol RequestConvertible {
  
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    
    var params: [URLQueryItem] { get }
    
    var url: URL? { get }
    var method: HttpMethod { get }
    var query: String? { get }
    func request() async throws -> URLRequest
}

public extension RequestConvertible {
    var scheme: String {
        "https"
    }
    
    var path: String {
        ""
    }
    
    var params: [URLQueryItem] {
        return []
    }
    
    var url: URL? {
        constructURL()
    }
    
    var query: String? {
        nil
    }
    
    func constructURL() -> URL? {
        var components = URLComponents()
        // Set the scheme, host, and path components
        components.scheme = scheme
        components.host = host
        components.path = "/\(path)"
        
        // Set the query items (if any)
        if !params.isEmpty {
            components.queryItems = params
        }
        // Construct and return the final URL
        return components.url
    }
}



//
//  GitHubRequestConvertible.swift
//  Packages
//
//  Created by Ram Kumar on 25/09/24.
//

import APIKit
import Foundation

public protocol GitHubRequestConvertible: RequestConvertible {
    func token() async throws -> String
}

public extension GitHubRequestConvertible {
    func request() async throws -> URLRequest {
        guard let url else { throw NetworkError.invalidURL }
        let token = try await token()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        if let query = query {
            let body = ["query": query]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return request
    }
}

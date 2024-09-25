//
//  request.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
 
import GitHubRequest

extension GitHubRequestConvertible {
    var host: String { "api.github.com" }
    
    func token() async throws -> String {
        return ""
    }
}

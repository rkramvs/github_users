//
//  request.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
 
import GitHubRequest
import Foundation

extension GitHubRequestConvertible {
    var host: String { "api.github.com" }
    
    func token() async throws -> String {
        return Bundle.main.object(forInfoDictionaryKey: "Access Token") as? String ?? ""
    }
}

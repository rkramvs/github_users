//
//  UserDetailAPI.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation
import APIKit
import GitHubRequest

struct UserDetailAPI: GitHubRequestConvertible {
    
    var method: HttpMethod { .get }
    
    var login: String
    
    init(login: String) {
        self.login = login
    }
    
    var path: String {
        return "users/\(login)"
    }
    
    func getUserDetail() async throws -> UserDetailModel {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try await APIKit.fetchDecodedData(self, session: .shared, responseType: UserDetailModel.self, jsonDecoder: jsonDecoder)
        return user
    }
}

//
//  UsersListAPI.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import GitHubRequest
import APIKit
import Foundation

class UsersListAPI: GitHubRequestConvertible {
    
    let perPage = 100
    
    enum FetchType {
        case `default`, search(text: String), nextPage
    }
    
    var path: String = "users"
    var method: HttpMethod = .get
    var page: Int = 1
    var searchText: String?
    
    var fetchType: FetchType = .default
    
    init(fetchType: FetchType) {
        self.fetchType = fetchType
    }

    var params: [URLQueryItem] {
        switch fetchType {
        case .default:
            return []
        case .search(text: let text):
            return []
        case .nextPage:
            return [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "per_page", value: String(perPage))]
        }
    }
    
    func getUsers(fetchType: FetchType) async throws -> [UserListModel] {
        self.fetchType = fetchType
        let users = try await APIKit.request(self, session: URLSession.shared, responseType: [UserListModel].self)
        return users
    }
}

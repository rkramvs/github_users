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
    
    enum FetchType {
        case `default`, search(text: String), nextPage
    }
    
    var path: String = "graphql"
    var method: HttpMethod = .post
    
    var hasMorePage: Bool = false
    var endCursor: String?
    
    var fetchType: FetchType = .default
    
    init(fetchType: FetchType) {
        self.fetchType = fetchType
    }
    
    var url: URL? {
        constructURL()
    }
        
    var query: String? {
        switch fetchType {
        case .search(let text):
                    """
                    {
                      search(query: "\(text) in:login \(text) in:name", type: USER, first: 20) {
                        edges {
                          node {
                            ... on User {
                              login
                              name
                              bio
                              url
                              avatarUrl
                              createdAt
                            }
                          }
                        }
                        pageInfo {
                          endCursor
                          hasNextPage
                        }
                      }
                    }
                    """
        default:
                    """
                    {
                      search(query: "type:user", type: USER, first: 50, after: "\(endCursor ?? "")") {
                        edges {
                          node {
                            ... on User {
                              login
                              name
                              bio
                              url
                              avatarUrl
                              createdAt
                            }
                          }
                        }
                        pageInfo {
                          endCursor
                          hasNextPage
                        }
                      }
                    }
                    """
        }
    }
    
    func getUsers(fetchType: FetchType) async throws -> [UserListModel] {
        self.fetchType = fetchType
        let response = try await APIKit.fetchDataWithResponse(self, session: URLSession.shared)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let model = try decoder.decode(GitHubSearchResponse.self, from: response.data)
        
        switch fetchType {
        case .search(_):
            break
        default:
            self.hasMorePage = model.data.search.pageInfo.hasNextPage
            self.endCursor = model.data.search.pageInfo.endCursor
        }
        
        return model.data.search.edges.compactMap { $0.node }
    }
}


struct GitHubSearchResponse: Decodable {
    let data: SearchData
}

// MARK: - Data and Search Wrapper
struct SearchData: Decodable {
    let search: SearchResult
}

// MARK: - Search Result Wrapper
struct SearchResult: Decodable {
    let edges: [Edge]
    let pageInfo: PageInfo
}

// MARK: - Edges and Node (User Info)
struct Edge: Decodable {
    let node: UserListModel?
    
    enum CodingKeys: CodingKey {
        case node
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.node = try? container.decodeIfPresent(UserListModel.self, forKey: .node)
    }
}

// MARK: - PageInfo for Pagination
struct PageInfo: Decodable {
    let endCursor: String?
    let hasNextPage: Bool
}

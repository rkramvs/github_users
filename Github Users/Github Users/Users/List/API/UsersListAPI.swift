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
    
    var path: String = "users"
    var method: HttpMethod = .get
    var nextPageURL: URL?
    
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
            return []
        }
    }
    
    var url: URL? {
        switch fetchType {
        case .default:
            return constructURL()
        case .search(text: let text):
            return constructURL()
        case .nextPage:
            return nextPageURL
        }
    }
    
    func getUsers(fetchType: FetchType) async throws -> [UserListModel] {
        self.fetchType = fetchType
        let response = try await APIKit.fetchDataWithResponse(self, session: URLSession.shared)
        getNextPageURL(from: response.httpResponse)
        let model = try JSONDecoder().decode([UserListModel].self, from: response.data)
        return model
    }
    
    private func getNextPageURL(from response: HTTPURLResponse) {
        if let linkHeader = response.allHeaderFields["Link"] as? String {
            // Split the header into parts
            let links = linkHeader.components(separatedBy: ",")
            
            // Iterate over each link
            var nextPageLinkFound: Bool = false
            for link in links {
                // Check if the current part contains the "rel=next" relation
                if link.contains("rel=\"next\"") {
                    // Extract the URL part from the link
                    let parts = link.components(separatedBy: ";")
                    if let urlPart = parts.first {
                        // Clean up the URL by removing < and >
                        let trimmedURL = urlPart.trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
                        nextPageURL = URL(string: trimmedURL)
                        nextPageLinkFound =  true
                    }
                }
            }
            
            if !nextPageLinkFound {
                nextPageURL = nil
            }
        }
        else {
            nextPageURL = nil
        }
    }

}

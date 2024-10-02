//
//  RepositoryAPI.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import Foundation
import APIKit
import GitHubRequest

class RepositoryAPI: GitHubRequestConvertible {
    
    enum FetchType {
        case `default`, nextPage
    }
    
    var path: String  { "users/\(login)/repos" }
    var method: HttpMethod = .get
    
    var url: URL? {
        switch fetchType {
        case .default: return constructURL()
        case .nextPage: return nextPageURL
        }
    }
    
    var login: String
    var fetchType: FetchType = .default
    var nextPageURL: URL?
    
    init(login: String) {
        self.login = login
    }

    func getRepositories(fetchType: FetchType) async throws -> [RepositoryModel] {
        self.fetchType = fetchType
        let response = try await APIKit.fetchDataWithResponse(self, session: URLSession.shared)
        getNextPageURL(from: response.httpResponse)
        let model = try JSONDecoder().decode([RepositoryModel].self, from: response.data)
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

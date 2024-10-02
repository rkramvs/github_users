//
//  UserImageDownloadAPI.swift
//  Github Users
//
//  Created by Ram Kumar on 28/09/24.
//

import GitHubRequest
import APIKit
import Foundation

class UsersImageDownloadAPI: GitHubRequestConvertible {
    
    public static var userImageSession: URLSession  = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = CustomExpiringURLCache.global
        return URLSession(configuration: configuration)
    }()
    
    
    var method: HttpMethod = .get
    
    var avatarURL: URL
    init(avatarURL: URL) {
        self.avatarURL = avatarURL
    }
    
    var url: URL? {
        avatarURL
    }
    
    func downloadImage() async throws -> Data {
        let data = try await APIKit.downloadData(self, session: UsersImageDownloadAPI.userImageSession)
        return data
    }
}


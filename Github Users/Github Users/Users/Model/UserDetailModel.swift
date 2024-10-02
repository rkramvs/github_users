//
//  UserDetailModel.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation

class UserDetailModel: Decodable {
    var login: String = ""
    var name: String?
    var url: URL?
    var avatarUrl: URL?
    var avatarData: Data?
    var bio: String?
    var followers: Int = 0
    var following: Int = 0
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var twitterUsername: String?
    var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case url
        case avatarUrl
        case bio
        case followers
        case following
        case company
        case blog
        case location
        case email
        case twitterUsername
        case createdAt
    }
    
    init() { }

    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.avatarUrl = try container.decodeIfPresent(URL.self, forKey: .avatarUrl)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.followers = try container.decode(Int.self, forKey: .followers)
        self.following = try container.decode(Int.self, forKey: .following)
        self.company = try container.decodeIfPresent(String.self, forKey: .company)
        self.blog = try container.decodeIfPresent(String.self, forKey: .blog)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.twitterUsername = try container.decodeIfPresent(String.self, forKey: .twitterUsername)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.createdAt = formatter.date(from: createdAtString)
    }
    
    var listModel: UserListModel {
        var listModel = UserListModel(login: login)
        listModel.name = name
        listModel.bio = bio
        listModel.url = url
        listModel.avatarUrl = avatarUrl
        listModel.avatarData = avatarData
        listModel.createdAt = createdAt
        return listModel
    }
}

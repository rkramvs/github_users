//
//  UserListModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
import Foundation
import UIKit

public struct UserListModel: Decodable, Hashable, Equatable {
    var login: String
    var name: String?
    var url: URL?
    var bio: String?
    var avatarUrl: URL?
    var avatarData: Data?
    var createdAt: Date?
    
    enum CodingKeys: CodingKey {
        case login
        case name
        case bio
        case url
        case avatarUrl
        case createdAt
    }
    
    public init(login: String) {
        self.login = login
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.avatarUrl = try container.decodeIfPresent(URL.self, forKey: .avatarUrl)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.createdAt = formatter.date(from: createdAtString)
    }
    
    public static func == (lhs: UserListModel, rhs: UserListModel) -> Bool {
        return lhs.login == rhs.login &&
        lhs.name == rhs.name &&
        lhs.bio == rhs.bio &&
        lhs.url == rhs.url &&
        lhs.avatarUrl == rhs.avatarUrl &&
        (lhs.avatarData == nil) == (rhs.avatarData == nil) &&
        lhs.createdAt == rhs.createdAt
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(login)
        hasher.combine(url)
        hasher.combine(avatarUrl)
        hasher.combine(name)
        hasher.combine(bio)
        hasher.combine(createdAt)
        if avatarData == nil {
            hasher.combine(0)
        } else {
            hasher.combine(1)
        }
    }
}

struct UserListCellContentConfiguration: Hashable, Equatable, UIContentConfiguration {
    var model: UserListModel
    
    public func makeContentView() -> UIView & UIContentView {
        UserListCellContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> Self  {
        return self
    }
    
    static func `default`() -> Self {
        return UserListCellContentConfiguration(model: UserListModel(login: ""))
    }
}

//
//  UserListModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
import Foundation

public struct UserListModel: Codable {
    var login: String
    var avatarUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

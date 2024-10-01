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
    
    init() { }
    
    var listModel: UserListModel {
        var listModel = UserListModel(login: login)
        listModel.name = name
        listModel.bio = bio
        listModel.avatarUrl = avatarUrl
        listModel.avatarData = avatarData
        listModel.createdAt = createdAt
        return listModel
    }
}

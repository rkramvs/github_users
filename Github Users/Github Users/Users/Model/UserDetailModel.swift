//
//  UserDetailModel.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation

class UserDetailModel: Decodable {
    var id: Int = 0
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
    
    init() { }
    
    var listModel: UserListModel {
        UserListModel(id: id, login: login, name: name, bio: bio, avatarUrl: avatarUrl, avatarData: avatarData)
    }
}

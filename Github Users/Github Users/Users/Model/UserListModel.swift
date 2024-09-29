//
//  UserListModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
import Foundation
import UIKit

public struct UserListModel: Codable, Hashable, Equatable {
    var id: Int
    var login: String
    var name: String?
    var bio: String?
    var avatarUrl: URL?
    var avatarData: Data?
    
    public static func == (lhs: UserListModel, rhs: UserListModel) -> Bool {
        return lhs.login == rhs.login &&
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.bio == rhs.bio &&
        lhs.avatarUrl == rhs.avatarUrl &&
        (lhs.avatarData == nil) == (rhs.avatarData == nil)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(login)
        hasher.combine(avatarUrl)
        hasher.combine(name)
        hasher.combine(bio)
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
        return UserListCellContentConfiguration(model: UserListModel(id: -1, login: "", avatarUrl: nil, avatarData: nil))
    }
}

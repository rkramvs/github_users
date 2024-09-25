//
//  UserListModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//
import Foundation
import UIKit

public struct UserListModel: Codable, Hashable, Equatable, UIContentConfiguration {
    var login: String
    var avatarUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    public static func == (lhs: UserListModel, rhs: UserListModel) -> Bool {
        return lhs.login == rhs.login
    }
    
    public func makeContentView() -> UIView & UIContentView {
        UserListCellContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> Self  {
        return self
    }
    
    static func `default`() -> Self {
        return UserListModel(login: "", avatarUrl: nil)
    }
}

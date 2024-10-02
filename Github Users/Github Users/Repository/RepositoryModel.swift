//
//  RepositoryModel.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import Foundation
import UIKit

struct RepositoryModel: Decodable, Hashable, Equatable, UIContentConfiguration  {
    
    var id: Int
    var name: String
    var description: String?
    var language: String?
    var htmlUrl: URL?
    var watchers: Int?
    var fork: Bool = false
    var `private`: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case htmlUrl = "html_url"
        case watchers
        case fork
        case `private`
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.htmlUrl = try container.decodeIfPresent(URL.self, forKey: .htmlUrl)
        self.watchers = try container.decodeIfPresent(Int.self, forKey: .watchers)
        self.fork = try container.decode(Bool.self, forKey: .fork)
        self.private = try container.decode(Bool.self, forKey: .private)
    }
    
    func makeContentView() -> any UIView & UIContentView {
        return RepositoryCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> RepositoryModel {
        self
    }
    
    static func `default`() -> Self {
        return RepositoryModel(id: 0, name: "")
    }
}

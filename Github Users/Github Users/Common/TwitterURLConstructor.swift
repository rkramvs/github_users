//
//  TwitterURLConstruction.swift
//  Github Users
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation

struct TwitterURLConstructor {
    static func url(for username: String) -> URL? {
        let urlString = "https://x.com/\(username)"
        return URL(string: urlString)
    }
}

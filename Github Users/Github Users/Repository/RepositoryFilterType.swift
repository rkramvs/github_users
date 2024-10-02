//
//  RepositoryFilterType.swift
//  Github Users
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation

enum RepositoryFilterType: String, CaseIterable {
    case allRepositories, nonForked, publicRepo
}

extension RepositoryFilterType {
    var displayText: String {
        switch self {
        case .allRepositories: return "All Repositories"
        case .nonForked: return "Non-Forked"
        case .publicRepo: return "Public Repositories"
        }
    }
    
    var filterTitle: String {
        switch self {
        case .allRepositories: return "Show All"
        case .nonForked: return "Non-Forked"
        case .publicRepo: return "Public"
        }
    }
}


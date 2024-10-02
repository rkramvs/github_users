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
        case .allRepositories: return "All Repositories".localised()
        case .nonForked: return "Non-Forked".localised()
        case .publicRepo: return "Public Repositories".localised()
        }
    }
    
    var filterTitle: String {
        switch self {
        case .allRepositories: return "Show All".localised()
        case .nonForked: return "Non-Forked".localised()
        case .publicRepo: return "Public".localised()
        }
    }
}


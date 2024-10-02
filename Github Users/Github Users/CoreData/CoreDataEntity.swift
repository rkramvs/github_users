//
//  CoreDataEntity.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData

enum CoreDataEntity: String {
    case users = "Users", languageColor = "LanguageColor", usersSearch = "UsersSearch"
}

extension CoreDataEntity {
    func entityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: rawValue, in: context)
    }
}
 

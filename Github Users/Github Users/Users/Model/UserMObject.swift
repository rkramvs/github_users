//
//  UserMObject.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData

class UserMObject: NSManagedObject {
    @NSManaged var databaseId: Int
    @NSManaged var login: String
    @NSManaged var name: String?
    @NSManaged var url: URL?
    @NSManaged var avatarUrl: URL?
    @NSManaged var avatarData: Data?
    @NSManaged var createdAt: Date?
    @NSManaged var bio: String?
    
    static func getFRC() -> NSFetchedResultsController<UserMObject> {
        let context = CoreDataHelper.shared.mainContext
        let fetchRequest: NSFetchRequest<UserMObject> = UserMObject.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "\(#keyPath(UserMObject.databaseId))", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 25
        let controller = NSFetchedResultsController<UserMObject>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    static func fetchRequest<T: NSFetchRequestResult>() -> NSFetchRequest<T> {
        NSFetchRequest<T>(entityName: CoreDataEntity.users.rawValue)
    }
    
    var listModel: UserListModel {
        var model = UserListModel(login: login)
        model.databaseId = databaseId
        model.name = name
        model.bio = bio
        model.url = url
        model.avatarUrl = avatarUrl
        model.avatarData = avatarData
        model.createdAt = createdAt
        return model
    }
    
    static func insert(user: UserListModel, context: NSManagedObjectContext) throws {
        let newUser = UserMObject(context: context)
        newUser.databaseId = user.databaseId
        newUser.login = user.login
        newUser.name = user.name
        newUser.url = user.url
        newUser.bio = user.bio
        newUser.avatarUrl = user.avatarUrl
        newUser.createdAt = user.createdAt
    }
    
    static func updateAvatarData(login: String, avatarData: Data?, in context: NSManagedObjectContext) throws {
        
        let fetchRequest: NSFetchRequest<UserMObject> = UserMObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login as NSString)
        let results = try context.fetch(fetchRequest)
        
        if let entity = results.first {
            entity.avatarData = avatarData
            try context.save()
        } else {
            throw NSError(domain: "UserMObject", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity with login \(login) not found"])
        }
    }
}

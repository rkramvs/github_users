//
//  UserMObject.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData

class UserMObject: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var login: String
    @NSManaged var name: String
    @NSManaged var avatarUrl: URL?
    @NSManaged var avatarData: Data?
    
    static func getFRC() -> NSFetchedResultsController<UserMObject> {
        let context = CoreDataHelper.shared.mainContext
        let fetchRequest: NSFetchRequest<UserMObject> = UserMObject.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "\(#keyPath(UserMObject.id))", ascending: true)
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
        UserListModel(id: id, login: login, avatarUrl: avatarUrl, avatarData: avatarData)
    }
    
    static func insert(user: UserListModel, context: NSManagedObjectContext) throws {
        let newUser = UserMObject(context: context)
        newUser.id = user.id
        newUser.login = user.login
        newUser.avatarUrl = user.avatarUrl
        try context.save()
    }
    
    static func updateAvatarData(id: Int, avatarData: Data?, in context: NSManagedObjectContext) throws {
        
        let fetchRequest: NSFetchRequest<UserMObject> = UserMObject.fetchRequest<UserMObject>()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let results = try context.fetch(fetchRequest)
        
        if let entity = results.first {
            entity.avatarData = avatarData
            try context.save()
        } else {
            throw NSError(domain: "UserMObject", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entity with id \(id) not found"])
        }
    }
}

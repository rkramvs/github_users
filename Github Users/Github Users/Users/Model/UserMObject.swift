//
//  UserMObject.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData

class UserMObject: NSManagedObject {
    @NSManaged var login: String
    @NSManaged var name: String
    @NSManaged var avatarURL: URL?
    
    
    static func getFRC() -> NSFetchedResultsController<UserMObject> {
        
        let context = CoreDataHelper.shared.mainContext
        let fetchRequest: NSFetchRequest<PasswordMObject> = NSFetchRequest(entityName: "Password")
        
        let sortDescriptor = NSSortDescriptor(key: "\(#keyPath(PasswordMObject.title))", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 25
        fetchRequest.returnsObjectsAsFaults = false
    
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "titleFirstCharacter", cacheName: nil)
        return controller
    }
}

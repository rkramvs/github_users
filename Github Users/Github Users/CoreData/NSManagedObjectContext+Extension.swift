//
//  NSManagedObject_Extension.swift
//  Github Users
//
//  Created by Ram Kumar on 28/09/24.
//

import CoreData

extension NSManagedObjectContext {
    
    func batchDelete(fetchRequest: NSFetchRequest<NSFetchRequestResult>, mergeTo contexts: [NSManagedObjectContext] = []) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let result = try self.execute(deleteRequest) as? NSBatchDeleteResult
        let objectIDArray = result?.result as? [NSManagedObjectID]
        let changes = [NSDeletedObjectsKey: objectIDArray]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: contexts)
        try save()
    }
    
}

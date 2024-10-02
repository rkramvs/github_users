//
//  LanguageColorMObject.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import Foundation
import CoreData

class LanguageColorMObject: NSManagedObject {
    @NSManaged var language: String
    @NSManaged var color: String
    
    static func fetchRequest<T: NSFetchRequestResult>() -> NSFetchRequest<T> {
        NSFetchRequest<T>(entityName: CoreDataEntity.languageColor.rawValue)
    }
    
    static func count(_ context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<LanguageColorMObject> = LanguageColorMObject.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Failed to count LanguageColorMObject: \(error)")
            return 0
        }
    }
    
    static func fetchColor(for language: String?, in context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<LanguageColorMObject> = LanguageColorMObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "language ==[c] %@", language ?? "")
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.color
        } catch {
            print("Failed to fetch color for language \(language): \(error)")
            return nil
        }
    }
}

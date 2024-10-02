//
//  LanguageColorDataHandler.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import Foundation
import CoreData

struct LanguageColorDataHandler {
    static func update() {
        
        let bgContext = CoreDataHelper.shared.bgContext
        
        bgContext.perform {
            guard LanguageColorMObject.count(bgContext) == 0 else { return }
            // Delete all existing records in the "LanguageColor" entity
            
            guard let fileURl = Bundle.main.url(forResource: "colors", withExtension: "json") else { return }
            
            guard let colorJsonData = try? Data(contentsOf: fileURl), let dict = try? JSONSerialization.jsonObject(with: colorJsonData, options: []) as? [String: [String: Any]] else { return }
            
            var objectDict: [[String: Any]] = [[:]]
            
            for (key, value) in dict {
                if let color = value["color"] as? String {
                    objectDict.append(["language": key, "color": color])
                }
            }
            
            guard !objectDict.isEmpty else { return }
            
            let batchInsertRequest = NSBatchInsertRequest(entityName: CoreDataEntity.languageColor.rawValue, objects: objectDict)
            
            do {
                try bgContext.execute(batchInsertRequest)
                try bgContext.save()
                print("Batch insert completed successfully.")
            } catch {
                print("Failed to batch insert LanguageColorMObject: \(error)")
            }
        }
    }
}



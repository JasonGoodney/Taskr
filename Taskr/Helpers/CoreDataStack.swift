//
//  CoreDataStack.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData


/*
    Creates a persistent container with the name of the  data model, "Taskr"
    Container with load ther persistent store if availble else create one
    MOC context is set from the persistent container's context
 */
enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
        
        return container
    }()
    
    static var context: NSManagedObjectContext{ return container.viewContext }
}


//
//  CoreDataHelper.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    static func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("There was an error in \(#function): \(error)\n\(error.localizedDescription)")
        }
    }
    
    
}

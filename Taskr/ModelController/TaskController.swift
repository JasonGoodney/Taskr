//
//  TaskController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let shared = TaskController()
    
    var tasks: [Task] {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(request)
        } catch let error {
            print("There was an error in \(#function): \(error)\n\(error.localizedDescription)")
        }
        
        return []
    }
    
    
}

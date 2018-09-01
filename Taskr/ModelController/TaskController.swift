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
    
    static let shared = TaskController() ; private init() {}
    
    let fetchResultsController: NSFetchedResultsController<Task> = {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "isComplete", ascending: true),
            NSSortDescriptor(key: "due", ascending: true)
        ]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("There was an error in \(#function): \(error)\n\(error.localizedDescription)")
        }
    }
    
    func addTask(with name: String, due: Date?, note: String?) {
        Task(name: name, note: note, due: due)
        saveToPersistentStore()
    }
    
    func update() {
        saveToPersistentStore()
    }
    
    func delete(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
    }
}



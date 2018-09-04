//
//  TaskController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

class TaskController: NotificationScheduler {
    
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
        let task = Task(name: name, note: note, due: due)
        saveToPersistentStore()
        scheduleUserNotifications(for: task)
    }
    
    func update(_ task: Task) {
        saveToPersistentStore()
        cancelUserNotifications(for: task)
        
        if !task.isComplete {
            scheduleUserNotifications(for: task)
        }
    }
    
    func delete(task: Task) {
        cancelUserNotifications(for: task)
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
    }
}




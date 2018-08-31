//
//  TaskController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

class TaskController: CRUDable {
    
    enum TaskKey {
        static let name = "name"
        static let note = "note"
        static let due = "due"
        static let isComplete = "isComplete"
    }
    
    static let shared = TaskController()
    
    init() {
        tasks = fetchTasks()
    }
    
    var tasks: [Task] {
        get {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            
            do {
                return try CoreDataStack.context.fetch(request)
            } catch let error {
                print("There was an error in \(#function): \(error)\n\(error.localizedDescription)")
            }
            return []
        }
        
        set {}
    }
}

// MARK: - CRUDable
extension TaskController {
    typealias Item = Task
    
    func add(dictionary: [String : Any]) {
        guard let name = dictionary[TaskKey.name] as? String,
            let note = dictionary[TaskKey.note] as? String else { return }
        
        Task(name: name, note: note)
        CoreDataHelper.saveToPersistentStore()
    }
    
    func update(item: Item, dictionary: [String : Any]) {
        guard let name = dictionary[TaskKey.name] as? String,
            let note = dictionary[TaskKey.note] as? String,
            let due = dictionary[TaskKey.due] as? Date else { return }
        
        item.name = name
        item.note = note
        item.due = due
        
        CoreDataHelper.saveToPersistentStore()
    }
    
    func remove(item: Item) {
        CoreDataStack.context.delete(item)
        CoreDataHelper.saveToPersistentStore()
    }
}

// MARK: - Methods
extension TaskController {
    func fetchTasks() -> [Task] {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(request)
        } catch let error {
            print("😳\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n👿")
        }
        
        return[]
    }
}

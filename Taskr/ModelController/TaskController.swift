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
    
    var mockTasks: [Task] = [
        Task(name: "Party"),
        Task(name: "Second Party", note: "After party", due: Date(), isComplete: true),
        Task(name: "🎄", note: "TO get 🎁")
    ]
    
}

extension TaskController: CRUDable {
    typealias Item = Task
    
    func add(dictionary: [String : Any]) {
        guard let name = dictionary[TaskKey.name] as? String,
            let note = dictionary[TaskKey.note] as? String,
            let due = dictionary[TaskKey.due] as? Date else { return }
        
        Task(name: name, note: note, due: due)
        CoreDataHelper.saveToPersistentStore()
    }
    
    func update(item: Item, dictionary: [String : Any]) {
        guard let name = dictionary[TaskKey.name] as? String,
            let note = dictionary[TaskKey.note] as? String,
            let due = dictionary[TaskKey.due] as? Date,
            let isComplete = dictionary[TaskKey.isComplete] as? Bool else { return }
        
        Task(name: name, note: note, due: due, isComplete: isComplete)
        CoreDataHelper.saveToPersistentStore()
    }
    
    func remove(item: Item) {
        CoreDataStack.context.delete(item)
        CoreDataHelper.saveToPersistentStore()
    }
}

extension TaskController {
    
    func fetchTasks() -> [Task] {
        return mockTasks
    }
}

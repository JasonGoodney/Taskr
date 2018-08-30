//
//  TaskListTableViewController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    // MARK: - Properties
    var tasks: [Task] {
        return TaskController.shared.tasks
    }
    let cellId = "taskCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

// MARK: - Methods
extension TaskListTableViewController {
    func toggleIsComplete(forTask task: Task) {
        task.isComplete = !task.isComplete
        CoreDataHelper.saveToPersistentStore()
    }
}

// MARK: - UITableViewDataSource
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        let task = tasks[indexPath.row]

        cell.delegate = self
        cell.update(withTask: task)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            TaskController.shared.remove(item: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - ButtonTableViewCellDelegate
extension TaskListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let task = tasks[indexPath.row]
        
        self.toggleIsComplete(forTask: task)
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Navigation
extension TaskListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.Segue.toUpdateDetail {
            guard let destinationVC = segue.destination as? TaskDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.task = tasks[index]
            destinationVC.dueDate = tasks[index].due            
        }
    }
}
































































































































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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - UITableViewDataSource
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TaskListTableViewCell else { return UITableViewCell() }
        
        let task = tasks[indexPath.row]

        cell.task = task
        
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

// MARK: - Navigation
extension TaskListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.Segue.toUpdateDetail {
            guard let destinationVC = segue.destination as? TaskDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.task = tasks[index]
        }
    }
}
































































































































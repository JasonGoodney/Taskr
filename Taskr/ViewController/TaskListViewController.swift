//
//  TaskListViewController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/31/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    // MARK: - Properties
    var tasks: [Task] {
        return TaskController.shared.fetchResultsController.fetchedObjects ?? []
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        TaskController.shared.fetchResultsController.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try TaskController.shared.fetchResultsController.performFetch()
        } catch let error {
            print("😳\nThere was an error in \(#function): \(error)\n\n\(error.localizedDescription)\n👿")
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return TaskController.shared.fetchResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = TaskController.shared.fetchResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.Cell.buttonTableViewCell, for: indexPath) as? ButtonTableViewCell
        let task = tasks[indexPath.row]
        
        cell?.delegate = self
        cell?.task = task
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            
            TaskController.shared.delete(task: task)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - ButtonTableViewCellDelegate
extension TaskListViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ cell: ButtonTableViewCell) {
        guard let task = cell.task else { return }
        task.isComplete = !task.isComplete
        cell.updateButton(from: task)
        TaskController.shared.update(task)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TaskListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            print(indexPath.section, indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
            
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet , with: .fade)
        default:
            break
        }
    }
}

// MARK: - Navigation
extension TaskListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.Segue.toUpdateDetail {
            guard let destinationVC = segue.destination as? TaskDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.task = tasks[index]
        }
    }
}

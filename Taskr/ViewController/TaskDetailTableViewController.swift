//
//  TaskDetailTableViewController.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    var task: Task?
    var dueDate: Date?
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
}

// MARK: - Methods
extension TaskDetailTableViewController {
    func updateView() {
        if isViewLoaded {
            guard let task = task, let due = task.due else { return }
            nameTextField.text = task.name
            noteTextView.text = task.note
            datePicker.date = due
        }
    }
    
    func updateTask() {
        guard let name = nameTextField.text,
            let note = noteTextView.text,
            let dueDate = dueDate else { return }
        
        let taskDictionary: [String : Any] = [
            TaskController.TaskKey.name : name,
            TaskController.TaskKey.note : note,
            TaskController.TaskKey.due : dueDate
        ]
        
        if let task = task {
            TaskController.shared.update(item: task, dictionary: taskDictionary)
        } else {
            TaskController.shared.add(dictionary: taskDictionary)
        }
    }
}

// MARK: - Actions
extension TaskDetailTableViewController {
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        updateTask()
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension TaskDetailTableViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Navigation
extension TaskDetailTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


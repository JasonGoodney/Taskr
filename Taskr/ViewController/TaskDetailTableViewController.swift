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
    var task: Task? {
        didSet {
            updateView()
        }
    }
    
    var dueDate: Date? 
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var taskDueTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
}

// MARK: - Methods
extension TaskDetailTableViewController {
    func updateView() {
        if isViewLoaded {
            guard let task = task else { return }
            nameTextField.text = task.name
            noteTextView.text = task.note
            taskDueTextField.text = task.due?.stringValue()
        }
        
        tableView.tableFooterView = UIView()
        setupDateTextField()
        hideKeyboardOnTap()
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
    
    func setupDateTextField() {
        taskDueTextField.inputView = dueDatePicker
    }
}

// MARK: - Actions
extension TaskDetailTableViewController {
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        updateTask()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        dueDate = sender.date
        taskDueTextField.text = dueDate?.stringValue()
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

// MARK: - Hide Keyboard Tap Gesture
extension UIViewController {
    func hideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


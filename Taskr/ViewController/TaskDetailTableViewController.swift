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
    
    var dueDate: Date?  {
        get { return task?.due }
        set { task?.due = newValue }
    }
    
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
        tableView.tableFooterView = UIView()
        setupDateTextField()
        setupNoteTextView()
        hideKeyboardOnTap()
        
        guard let task = task else { return }
        nameTextField.text = task.name
        noteTextView.text = task.note
        
        if let due = task.due {
            taskDueTextField.text = due.stringValue()
        } else {
            taskDueTextField.text = Date().stringValue()
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
    
    func setupDateTextField() {
        taskDueTextField.inputView = dueDatePicker
        guard let dueDate = dueDate else { return }
        dueDatePicker.date = dueDate
    }
    
    func setupNoteTextView() {
        noteTextView.addShadow()
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

// MARK: - UIView Shadow
extension UIView {
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = #colorLiteral(red: 0.676662234, green: 0.676662234, blue: 0.676662234, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = 5
    }
}


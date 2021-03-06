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
            loadViewIfNeeded()
            updateView()
        }
    }
    var dueDate: Date? {
        get { return task?.due ?? Date() }
        set (newDate) {
            guard let task = task else { return }
            task.due = newDate
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var taskDueTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateView()
    }
}

// MARK: - Update View
extension TaskDetailTableViewController {
    func updateView() {
        setupDueDatePicker()
        hideKeyboardOnTap()
        
        guard let task = task else { return }
        nameTextField.text = task.name
        noteTextView.text = task.note

        navigationItem.title = task.name ?? "New Task"
    }
    
    func updateTask() {
        guard let name = nameTextField.text, !name.isEmpty,
            let note = noteTextView.text else { return }
            let dueDate = dueDatePicker.date
        
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
    
    func setupDueDatePicker() {
        guard let dueDate = dueDate else { return }
        dueDatePicker.date = dueDate
        setupDueTextField(with: dueDate)
    }
    
    func setupDueTextField(with dueDate: Date) {
        taskDueTextField.inputView = dueDatePicker
        taskDueTextField.text = dueDate.stringValue()
        taskDueTextField.tintColor = .clear
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Actions
extension TaskDetailTableViewController {
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        updateTask()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        taskDueTextField.text = sender.date.stringValue()
        dueDate = sender.date
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

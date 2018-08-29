//
//  TaskListTableViewCell.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var task: Task? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDueLabel: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
}

// MARK: - View Setup
extension TaskListTableViewCell {
    func updateView() {
        guard let task = task else { return }
        
        taskNameLabel.text = task.name
        
        if task.isComplete {
            isCompleteButton.setTitle("👍", for: .normal)
        } else {
            isCompleteButton.setTitle("👎", for: .normal)
        }
    }
}

// MARK: - Actions
extension TaskListTableViewCell {
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
    }
}

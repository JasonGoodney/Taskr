//
//  ButtonTableViewCell.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ cell: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: ButtonTableViewCellDelegate?
    var task: Task? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
}

// MARK: - View Update
extension ButtonTableViewCell {
    func updateView() {
        guard let task = task else { return }
        primaryLabel.text = task.name
        dueDateLabel.text = task.due?.toString()
        
        updateButton(from: task)
    }
    
    func updateButton(from task: Task) {
        if task.isComplete {
            completeButton.setTitle("🙌", for: .normal)
            primaryLabel.textColor = .lightGray
        } else {
            completeButton.setTitle("🐴", for: .normal)
            primaryLabel.textColor = .darkGray
        }

    }
}

// MARK: - Actions
extension ButtonTableViewCell {
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonCellButtonTapped(self)
    }
}

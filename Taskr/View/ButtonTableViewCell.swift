//
//  ButtonTableViewCell.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: ButtonTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
}

// MARK: - View Update
extension ButtonTableViewCell {

    func updateButton(_ isComplete: Bool) {
        
        if isComplete {
            completeButton.setTitle("🙌", for: .normal)
        } else {
            completeButton.setTitle("🐴", for: .normal)
        }
    }
    
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        
        updateButton(task.isComplete)
        setupLabelStyle()
    }
    
    func setupLabelStyle() {
        primaryLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
}

// MARK: - Actions
extension ButtonTableViewCell {
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(self)
        }
    }
}

//
//  CRUDable.swift
//  Taskr
//
//  Created by Jason Goodney on 8/29/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

protocol CRUDable {
    
    associatedtype Item
    
    func add(dictionary: [String : Any])
    func update(item: Item, dictionary: [String : Any])
    func remove(item: Item)
}

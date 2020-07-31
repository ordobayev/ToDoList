//
//  GroupItem.swift
//  ToDoList
//
//  Created by Нургазы on 7/14/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation

class GroupItem: NSObject, Codable {
    var name: String
    var iconName: String
    var items = [ChecklistItem]()
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) { $0 + ($1.checked ? 0 : 1)
        }
    }
}

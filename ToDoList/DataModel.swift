//
//  DataModel.swift
//  ToDoList
//
//  Created by Нургазы on 7/18/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [GroupItem]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func sortGroupItems() {
        lists.sort { list1, list2 in
            return list1.name.localizedCompare(list2.name) == .orderedAscending
    } // сравнение для сортировки
}
    // MARK: Documents folder

    func documentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path
    }

    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    // Mark: UserDefaults
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex":-1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let firstTime = UserDefaults.standard.bool(forKey: "FirstTime")
        
        if firstTime {
            lists.append(GroupItem(name: "List"))
            
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func newChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }

    // MARK: - Saving items and loading items

    func saveChecklists() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(lists)

            try data.write(to: dataFilePath(), options: .atomic)

        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func loadChecklists() {
        let path = dataFilePath()

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()

            do {
                lists = try decoder.decode([GroupItem].self, from: data)
                sortGroupItems()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

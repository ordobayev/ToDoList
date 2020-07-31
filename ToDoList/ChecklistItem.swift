//
//  ChecklistItem.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 6/25/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    
//    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
//        lhs.text == rhs.text && lhs.checked == rhs.checked
//    }
    
    var text: String
    var checked: Bool
    var itemId: Int = -1
    var shouldRemind: Bool = false
    var date: Date = Date()
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemId += DataModel.newChecklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked(){
        checked.toggle()
    }
    
    func configureNotification() {
        if shouldRemind && date > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = self.text
            content.sound = .default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(self.itemId)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            print("New Notification id: \(itemId)")
        }
        
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(self.itemId)"])
    }
    
}

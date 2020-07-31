//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 6/30/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

protocol AddItemVCDelegate: class {
    func addItemVCDidCancel(_ controller: AddItemViewController)
    func addItemVCAdd(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    func addItemVCEdit(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: AddItemVCDelegate? // delegate = CheckListViewController
    var itemToEdit: ChecklistItem?
    var date = Date()
    var datePickerVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        if let item = itemToEdit {
            navigationItem.title = "Edit Item"
            textField.text = item.text
            doneButton.isEnabled = true
            reminderSwitch.isOn = item.shouldRemind
            date = item.date
        }
//        navigationItem.largeTitleDisplayMode = .never
        updateDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    @IBAction func cancel() {
        delegate?.addItemVCDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = reminderSwitch.isOn
            item.date = date
            
            delegate?.addItemVCEdit(self, didFinishEditing: item)
        } else {
        let item = ChecklistItem(text: textField.text!, checked: false)
            
            item.shouldRemind = reminderSwitch.isOn
            item.date = date
            item.configureNotification()
            delegate?.addItemVCAdd(self, didFinishAdding: item)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        date = sender.date
        updateDateLabel()
    }
    @IBAction func remindChanged(_ sender: UISwitch) {
        textField.resignFirstResponder()
        
        if sender .isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // nothing
            }
        }
    }
    
    
    
    // MARK - Helper Methods
    
    func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: date)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexForDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexForDatePicker], with: .fade)
        datePicker.setDate(date, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexForDatePicker = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexForDatePicker], with: .fade)
        }
    }
    
    // MARK: - Table View Delegate
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        return nil
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndex = indexPath
        
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndex = IndexPath(row: 0, section: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: newIndex)
    }
    
    // MARK: - TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButton.isEnabled = newText.isEmpty ? false : true
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
}

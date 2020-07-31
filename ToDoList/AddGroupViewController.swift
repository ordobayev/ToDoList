//
//  AddGroupViewController.swift
//  ToDoList
//
//  Created by Нургазы on 7/14/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

protocol GroupDetailVCDelegate: class {
    func addGroupVCDidCancel(_ controller: AddGroupViewController)
    func addGroupVCDone(_ controller: AddGroupViewController, didFinishAdding item: GroupItem)
    func addGroupVCEdit(_ controller: AddGroupViewController, didFinishEditing item: GroupItem)
}

class AddGroupViewController: UITableViewController, UITextFieldDelegate, IconPickerVCDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    weak var delegate: GroupDetailVCDelegate? // Delegate = GroupViewController 
    var groupItemToEdit: GroupItem?
    var iconName = "No Icon"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if let itemToEdit = groupItemToEdit {
            navigationItem.title = "Edit Item"
            textField.text = itemToEdit.name
            doneButton.isEnabled = true
            iconName = itemToEdit.iconName
        }
        
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // В приоритете textfield - показывает клавиатуру
    }
    
    @IBAction func cancel() {
        delegate?.addGroupVCDidCancel(self) // GroupViewController.addgroupVCDidCancel вызов функции
    }

    @IBAction func done() {
        if let itemToEdit = groupItemToEdit {
            itemToEdit.name = textField.text!
            itemToEdit.iconName = iconName
            delegate?.addGroupVCEdit(self, didFinishEditing: itemToEdit)
        } else {
            let item = GroupItem(name: textField.text!, iconName: iconName)
            delegate?.addGroupVCDone(self, didFinishAdding: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "iconPicker" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    
    
    
    // MARK: - Text Field Delegates
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let oldText = textField.text!
//        let stringRange = Range(range, in: oldText)!
//        let newText = oldText.replacingCharacters(in: stringRange, with: string)
//
//        doneButton.isEnabled = newText.isEmpty ? false : true
//
//        return true
//    }
    
    @IBAction func didTextChanged(_ sender: Any) {
        doneButton.isEnabled = textField.text == "" ? false : true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    // MARK: - IconPickerViewController Delegate
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
}

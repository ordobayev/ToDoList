//
//  ChecklistViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 6/25/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemVCDelegate {

    var checklist: GroupItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
        
//        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            
            controller.delegate = self // AddItemViewController.delegate = ChecklistViewController
        } else if segue.identifier == "EditItem" {
            let controller = segue .destination as! AddItemViewController
            controller.delegate = self // AddItemViewController.delegate = ChecklistViewController
            
            if let indexpath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexpath.row]
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        let item = checklist.items[indexPath.row]
        print(indexPath.section)
        
        configureText(for: cell, with: item)
        configureCheckMark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            configureCheckMark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }

    
    // MARK: - Helping methods
    
    func configureCheckMark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(3) as! UILabel
        label.text = item.checked ? "✔︎" : ""
//        cell.accessoryType = item.checked ? .checkmark : .none
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
    }
    
    // MARK: - AddItemVC Delegate
    
    func addItemVCDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemVCAdd(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)

    }
    
    func addItemVCEdit(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
}

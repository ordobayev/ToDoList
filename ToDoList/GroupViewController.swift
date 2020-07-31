//
//  GroupViewController.swift
//  ToDoList
//
//  Created by Нургазы on 7/14/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit
/*
 нам не нужно сохранять все на каждом шагу или после каждого шага.
 Поэтому будет умнее предоставить эту отвественность оперативной памяти, а нам сохранить в постоянной памяти только перед закрытием.
 НО!
 Приложение может закрыться произвольно:
 1) Утечка памяти
 2) Ошибка в коде
 3) Потеряться в оперативной памяти (пассивная работа в background)
 
 Все эти сценарии проработаны заранее.
 */
/*
 Цель контроллера связывать данные
 */

class GroupViewController: UITableViewController, GroupDetailVCDelegate, UINavigationControllerDelegate {
    

    let cellId = "ChecklistCell" // Identifier of cell on checklistController
    var dataModel: DataModel! //он должен обязательно существовать

    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.lists = dataModel.lists.sorted(by: { $0.name > $1.name })
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId) // Должен показать существующую ячейку
    }
    
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
        navigationController?.delegate = self // навигационный контроллер сообщает о каких то действиях
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "showChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? GroupItem
        } else if segue.identifier == "createNew" {
        let controller = segue.destination as! AddGroupViewController
        controller.delegate = self
        }
    }
    // MARK: - Table view data source
        
        // Какое количество ячеек должно возвращаться - сколько имеем данных столько и возвращай
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataModel.lists.count
        }
        
        // Что хранит в себе ячейка: Текстлейбел, едитбаттон
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
            if let c = tableView.dequeueReusableCell(withIdentifier: cellId) {
                cell = c
            } else {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
            }
            
        let groupItem = dataModel.lists[indexPath.row]
            
            let count = groupItem.countUncheckedItems()
            
        cell.textLabel!.text = groupItem.name
            cell.imageView!.image = UIImage(named: groupItem.iconName)
            if groupItem.items.count == 0 {
                cell.detailTextLabel!.text = "No Items"
            } else {
                cell.detailTextLabel!.text = count == 0 ? "All done" : "\(count) Ramaining"
            }
        cell.accessoryType = .detailDisclosureButton
        
        return cell
        }
        
        // Переход на другую страницу
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            dataModel.indexOfSelectedChecklist = indexPath.row // При нажатии какого то индекса мы переходим и сохраняем информацию
            let checklist = dataModel.lists[indexPath.row] // определяет какую ячейку нажимаете
            performSegue(withIdentifier: "showChecklist", sender: checklist)
        
        }
        
        // Удаление ячейки
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            dataModel.lists.remove(at: indexPath.row) // Удаление с модели данных
            
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic) // Удаление ячейки
        }
        // Нажатие на Accessorytype - Edit
        override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            // Переход на сторибоард с помощью его ID
            let controller = storyboard?.instantiateViewController(identifier: "AddGroupVC") as! AddGroupViewController
            
            controller.delegate = self // delegate = GroupViewController
            let item = dataModel.lists[indexPath.row] //
            controller.groupItemToEdit = item // addGroupVC.groupItemToEdit = Item
            
            navigationController?.pushViewController(controller, animated: true) // создали контроллер и добавили поверх view
        }
    
        // MARK: Navigation Conroller Delegate
        // при возврате назад удаляет хранение которую сохранил UserDefaults.standard.set
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            
            print("NavigationControllerDelegate")
            
            if viewController === self {
                dataModel.indexOfSelectedChecklist = -1 // Сохранил несуществующий индекс, получается ничего
            }
    }
        
    }

    // MARK: - GroupDetailVCDelegate

    extension GroupViewController {
        func addGroupVCDidCancel(_ controller: AddGroupViewController) {
            navigationController?.popViewController(animated: true)
           }
        
        func addGroupVCDone(_ controller: AddGroupViewController, didFinishAdding item: GroupItem) {
            dataModel.lists.append(item) // index of this item = newRowIndex
            dataModel.sortGroupItems()
            tableView.reloadData() // перезагрузить дату
            
            navigationController?.popViewController(animated: true)
        }
        
        func addGroupVCEdit(_ controller: AddGroupViewController, didFinishEditing item: GroupItem) {
            dataModel.sortGroupItems()
            tableView.reloadData()
            
            navigationController?.popViewController(animated: true)
    }
}

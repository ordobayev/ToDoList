//
//  IconPickerViewController.swift
//  ToDoList
//
//  Created by Нургазы on 7/23/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

protocol IconPickerVCDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {

    weak var delegate: IconPickerVCDelegate?
    let icons = ["Activities", "Appointments", "Birthdays", "Chores", "Documents", "Drinks", "Favorites", "Folder", "Liked", "Music", "No Icon", "Photos", "Places", "Shopping", "Smile", "Trips"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPick: iconName)
    }
}

//
//  ListViewControllerTableViewController.swift
//  GroceryDemo
//  Created by Abdoulaye Diallo on 2/10/18.
//  Copyright © 2018 Abdoulaye Diallo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ListViewControllerTableViewController: UITableViewController {
    let listUsers = "ListUsers"
    let itemCellIdentifier = "ItemCell"
    var items : [Item] = []
    var user : User!
    var userCountBarItem: UIBarButtonItem!
    let itemsReference = Database.database().reference(withPath: "items")
    let usersReference = Database.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarItem = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(userCountButtonTouched))
        
        userCountBarItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarItem
        
        itemsReference.observe(.value) { (snapshot) in
            print(snapshot)
        }
        
        itemsReference.queryOrdered(byChild: "completed").observe(.value) {
            (snapshot) in
            var newItems :  [Item] = []
            
            for item in snapshot.children {
                let  groceryitem = Item(snapshot: item as! DataSnapshot)
                newItems.append(groceryitem)
            }
            self.items = newItems
            self.tableView.reloadData()
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.user = User(uid: user.uid, email: user.email!)
                let currentUserReference = self.usersReference.child(self.user.uid)
                currentUserReference.setValue(self.user.uid)
                currentUserReference.onDisconnectRemoveValue()
            }
        }
        usersReference.observe(.value) { (snapshot) in
            if snapshot.exists(){
                self.userCountBarItem?.title = snapshot.childrenCount.description
                
            } else {
                self.userCountBarItem?.title = "0"
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func addButtonTouch(_ sender: Any) {
        
        let alert = UIAlertController(title: "Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert )
        
        let save = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alert.textFields![0]
            let groceryItem = Item(name: textField.text!,
                                   addedByUser: self.user.email,
                                   completed: false)
            self.items.append(groceryItem)
            self.tableView.reloadData()
            
            let groceryItemRef = self.itemsReference.child(textField.text!.lowercased())
            let values = [ "name": textField.text!.lowercased(), "addedByUser": self.user.email, "completed": false ] as [String : Any]
            
            groceryItemRef.setValue(values)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source
    
    @objc func userCountButtonTouched()  {
        performSegue(withIdentifier: listUsers, sender: nil)
    }
    
    func toggleCellCheckBox(_ cell: UITableViewCell,  isCompleted:Bool) {
        
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
}

extension ListViewControllerTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier , for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.addedByUser
        toggleCellCheckBox( cell, isCompleted: item.completed)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            //  groceryItem.ref?.removeValue()
            groceryItem.ref?.setValue(nil)
            items.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) else { return }
        var item = items[indexPath.row]
        let toggledCompletion =  !item.completed
        toggleCellCheckBox(cell, isCompleted: toggledCompletion)
        item.completed = toggledCompletion
        item.ref?.updateChildValues(["completed": toggledCompletion])
        tableView.reloadData()
        
    }
}

//
//  OnlineTableViewController.swift
//  GroceryDemo
//
//  Created by Abdoulaye Diallo on 2/10/18.
//  Copyright © 2018 Abdoulaye Diallo. All rights reserved.
//

import UIKit

class OnlineTableViewController: UITableViewController {
    
    let userCell = "UserCell"
    var users: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signoutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension OnlineTableViewController {
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail =  users[ indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
}

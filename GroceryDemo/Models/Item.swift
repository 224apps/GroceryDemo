//
//  Item.swift
//  GroceryDemo
//
//  Created by Abdoulaye Diallo on 2/10/18.
//  Copyright © 2018 Abdoulaye Diallo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


struct Item {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    
    var completed: Bool
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "" ) {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
    }
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"]  as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed  = snapshotValue["completed"] as!  Bool
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return ["name": name, "addedByUser": addedByUser, "completed": completed ]
    }
    
    
    
    
    
}


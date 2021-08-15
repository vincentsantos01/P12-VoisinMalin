//
//  User.swift
//  VoisinMalin
//
//  Created by vincent on 30/07/2021.
//

import Foundation
import Firebase

struct Userssssss {
    let username: String
    let mail: String
    let userID: String
    
    init(username: String, mail: String, userID: String) {
        self.username = username
        self.mail = mail
        self.userID = userID
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let username = value["username"] as? String,
            let mail = value["mail"] as? String,
            let userID = value["userID"] as? String else {
                return  nil
        }
        self.username = username
        self.mail = mail
        self.userID = userID
    }
    
}

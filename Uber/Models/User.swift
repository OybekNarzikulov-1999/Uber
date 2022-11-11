//
//  User.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import Foundation


struct User {
    var name: String
    var email: String
    var accountType: Int
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as! Int
    }
    
}

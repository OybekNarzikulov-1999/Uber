//
//  User.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import Foundation
import CoreLocation


struct User {
    var name: String
    var email: String
    var accountType: Int
    var location: CLLocation?
    var uid: String
    
    init(uid: String, dictionary: [String:Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as! Int
        self.uid = uid
    }
    
}

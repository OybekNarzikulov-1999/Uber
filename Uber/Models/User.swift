//
//  User.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import Foundation
import CoreLocation

enum AccountType: Int {
    case pessenger
    case driver
}

struct User {
    var name: String
    var email: String
    var accountType: AccountType!
    var location: CLLocation?
    var uid: String
    var homeLocation: String?
    var workLocation: String?
    
    var firstInitial: String {return String(name.prefix(1))}
    
    init(uid: String, dictionary: [String:Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.uid = uid
        
        if let home = dictionary["homeLocation"] as? String {
            self.homeLocation = home
        }
        
        if let work = dictionary["workLocation"] as? String {
            self.workLocation = work
        }
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
        
    }
    
}

//
//  Service.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(User) -> Void){
        
        REF_USERS.child(currentUid!).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let user = User(dictionary: dictionary)
            completion(user)
            
            print(user.name)
            print(user.email)
            print(user.accountType)
            
        }
        
    }
    
}

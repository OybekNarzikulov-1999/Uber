//
//  Service.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import Foundation
import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = Database.database().reference().child("driver-locations")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void){
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
            
        }
        
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void){
        
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        REF_DRIVER_LOCATIONS.observe(.value) { snapshot in
            
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: {(uid, location) in
                
                fetchUserData(uid: uid) { user in
                    
                    var driver = user
                    driver.location = location
                    completion(driver)
                    
                }
                
            })
            
        }
        
    }
    
}

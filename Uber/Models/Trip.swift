//
//  Trip.swift
//  Uber
//
//  Created by Oybek Narzikulov on 16/11/22.
//

import CoreLocation

enum TripState: Int {
    case requested
    case accepted
    case driverArrived
    case inprogress
    case completed
}

struct Trip {
    
    var pickupCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var pessengerUid: String!
    var driverUid: String?
    var state: TripState!
    
    init(pessengerUid: String, dictionary: [String: Any]) {
        
        self.pessengerUid = pessengerUid
        
        if let pickupCoordinate = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoordinate[0] as? CLLocationDegrees else {return}
            guard let long = pickupCoordinate[1] as? CLLocationDegrees else {return}
            
            self.pickupCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoordinate = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinate[0] as? CLLocationDegrees else {return}
            guard let long = destinationCoordinate[1] as? CLLocationDegrees else {return}
            
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
        
    }
    
}



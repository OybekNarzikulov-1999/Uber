//
//  DriverAnnotation.swift
//  Uber
//
//  Created by Oybek Narzikulov on 13/11/22.
//

import Foundation
import MapKit


class DriverAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.3) {
            self.coordinate = coordinate
        }
    }
    
}

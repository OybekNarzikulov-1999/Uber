//
//  File.swift
//  Uber
//
//  Created by Oybek Narzikulov on 10/11/22.
//

import UIKit
import SnapKit
import MapKit

extension UIView{
    
    func addShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    func setDimensions(height: Double? = nil, width: Double? = nil){
        self.snp.makeConstraints { make in
            make.height.equalTo(height as! ConstraintRelatableTarget)
            make.width.equalTo(width as! ConstraintRelatableTarget)
        }
    }
    
}


extension MKPlacemark {
    
    var address: String? {
        get {

            guard let subThoroughfare = subThoroughfare else {return nil}
            guard let thoroughfare = thoroughfare else {return nil}
            guard let locality = locality else {return nil}
            guard let adminArea = administrativeArea else {return nil}

            return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea)"
            
        }
    }
    
}


extension MKMapView {
    
    func zoomToFit(annotations: [MKAnnotation]){
        
        var zoomRect = MKMapRect.null
        
        annotations.forEach { annotation in
            
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
            
        }
        
        let insets = UIEdgeInsets(top: 100, left: 150, bottom: 400, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
        
    }
    
}

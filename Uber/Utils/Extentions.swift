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
    
    func addAnnotationAndSelect(forCoordinate coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
    
}

extension UIViewController {
    
    func presentAlertController(withTitle title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func shouldPresentLoadingView(_ present: Bool, message: String? = nil){
        
        if present {
            
            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .black
            loadingView.alpha = 0
            loadingView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .whiteLarge
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = .systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.87
            
            view.addSubview(loadingView)
            loadingView.addSubview(indicator)
            loadingView.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.centerX.equalTo(view)
                make.top.equalTo(indicator.snp.bottom).offset(32)
            }
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else {
            view.subviews.forEach { subview in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.3) {
                        subview.alpha = 0
                    } completion: { _ in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
}

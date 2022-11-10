//
//  File.swift
//  Uber
//
//  Created by Oybek Narzikulov on 10/11/22.
//

import UIKit
import SnapKit

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

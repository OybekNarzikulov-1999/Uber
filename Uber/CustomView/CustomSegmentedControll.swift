//
//  CustomSegmentedControll.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit
import SnapKit

class CustomSegmentedControll: UIView {

    func initViews(){
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .white
        self.addSubview(imageView)
        
        let segmentedControll = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.87)], for: .normal)
        segmentedControll.selectedSegmentIndex = 0
        segmentedControll.layer.borderWidth = 0.5
        segmentedControll.layer.borderColor = UIColor.white.cgColor
        self.addSubview(segmentedControll)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        self.addSubview(underlineView)
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(4)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        segmentedControll.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.width.equalTo(self.snp.width)
        }
        
        underlineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(segmentedControll.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width)
        }
        
    }
    
    

}

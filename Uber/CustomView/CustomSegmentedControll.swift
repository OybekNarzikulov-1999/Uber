//
//  CustomSegmentedControll.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit
import SnapKit

class CustomSegmentedControll: UIView {
    
    //MARK: - Variables
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .white
        return imageView
        
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.87)], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderWidth = 0.5
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        return segmentedControl
        
    }()
    
    lazy var underlineView: UIView = {
       
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        return underlineView
        
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        
        self.addSubview(imageView)
        self.addSubview(segmentedControl)
        self.addSubview(underlineView)
        
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(4)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalTo(0)
            make.width.equalTo(self.snp.width)
        }
        
        underlineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width)
        }
        
    }
    
    

}

//
//  CustomUIView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 08/11/22.
//

import UIKit
import SnapKit

class CustomUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(image: String){
        
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(systemName: image)
        imageIcon.tintColor = .white
        imageIcon.alpha = 0.8
        self.addSubview(imageIcon)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        self.addSubview(underlineView)
        
        
        imageIcon.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
        
        underlineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(imageIcon.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width)
        }
        
    }

}

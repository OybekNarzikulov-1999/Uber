//
//  CustomUIView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 08/11/22.
//

import UIKit
import SnapKit

class CustomUIView: UIView {
    
    //MARK: - Variables
    
    var iconImage = ""
    var placeholder = ""
    
    
    lazy var imageIcon: UIImageView = {
        
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(systemName: iconImage)
        imageIcon.tintColor = .white
        imageIcon.alpha = 0.8
        return imageIcon
        
    }()
    
    lazy var underlineView: UIView = {
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        return underlineView
        
    }()
    
    lazy var customTextField: UITextField = {
       
        let textField = UITextField()
        textField.textColor = .white
        textField.borderStyle = .none
        textField.contentHorizontalAlignment = .left
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        textField.keyboardAppearance = .dark
        textField.font = .systemFont(ofSize: 16)
        return textField
        
    }()
    
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func initViews(){
        
        self.addSubview(imageIcon)
        self.addSubview(underlineView)
        self.addSubview(customTextField)
        
        imageIcon.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
        
        customTextField.snp.makeConstraints { make in
            make.left.equalTo(imageIcon.snp.right).offset(5)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(3)
        }
        
        underlineView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(imageIcon.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width)
        }
        
    }
    
    
}

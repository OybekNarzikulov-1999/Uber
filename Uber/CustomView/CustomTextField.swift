//
//  CustomTextField.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit
import SnapKit

class CustomTextField: UIView {
    
    var onText: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(image: String, placeholder: String, isPassword: Bool){
        
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(systemName: image)
        imageIcon.tintColor = .white
        imageIcon.alpha = 0.8
        self.addSubview(imageIcon)
        
        let textField = UITextField()
        textField.textColor = .white
        textField.borderStyle = .none
        textField.isSecureTextEntry = isPassword
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        textField.keyboardAppearance = .dark
        if let onText = onText {
            onText(textField.text ?? "")
        }
        textField.font = .systemFont(ofSize: 16)
        
        self.addSubview(textField)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        self.addSubview(underlineView)

        
        imageIcon.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
        
        textField.snp.makeConstraints { make in
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
    


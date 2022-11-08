//
//  CustomTextField.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initViews(placeholder: String){
        
        textColor = .white
        borderStyle = .none
        contentHorizontalAlignment = .left
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        keyboardAppearance = .dark
        font = .systemFont(ofSize: 16)
        
        
    }
}
    


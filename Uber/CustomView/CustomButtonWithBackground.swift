//
//  CustomBorderButton.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit

class CustomButtonWithBackground: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onAction: ((Bool) -> Void)?
    
    func initViews(buttonText: String){
        
        self.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        self.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.setTitle(buttonText, for: .normal)
        self.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed(){
        if let onAction = onAction {
            onAction(true)
        }
    }
    
}

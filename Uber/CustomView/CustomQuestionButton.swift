//
//  CustomSignUpButton.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit

class CustomQuestionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onAction: ((Bool) -> Void)?
    
    func initViews(questionText: String, buttonText: String){

        let attributedTitle = NSMutableAttributedString(string: questionText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: buttonText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        self.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @objc func handleShowSignUp(){
        if let onAction = onAction {
            onAction(true)
        }
    }
}

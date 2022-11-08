//
//  SignUpViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 03/11/22.
//

import UIKit
import FirebaseCore

class SignUpViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
       
        let titleLabel = UILabel()
        titleLabel.text = "UBER"
        titleLabel.textColor = UIColor.white
        titleLabel.font = .systemFont(ofSize: 36)
        return titleLabel
        
    }()
       
    private lazy var emailContainerView: CustomUIView = {
        
        let view = CustomUIView()
        view.initViews(image: "envelope")
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(36)
            make.top.equalTo(view.snp.top).offset(3)
            make.right.equalTo(view.snp.right)
        }
        
        return view
        
    }()
    
    private lazy var emailTextField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.initViews(placeholder: "Email")
        return textField
        
    }()
    
    private lazy var fullnameContainerView: CustomUIView = {
        
        let view = CustomUIView()
        view.initViews(image: "person")
        
        view.addSubview(fullnameTextField)
        fullnameTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(36)
            make.top.equalTo(view.snp.top).offset(3)
            make.right.equalTo(view.snp.right)
        }
        
        return view
        
    }()
    
    private lazy var fullnameTextField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.initViews(placeholder: "Fullname")
        return textField
        
    }()
    
    private lazy var passwordContainerView: CustomUIView = {
        
        let view = CustomUIView()
        view.initViews(image: "lock")
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(36)
            make.top.equalTo(view.snp.top).offset(3)
            make.right.equalTo(view.snp.right)
        }
        
        return view
        
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        
        let textField = CustomTextField()
        textField.initViews(placeholder: "Password")
        return textField
        
    }()
    
    private lazy var segmentedControll: CustomSegmentedControll = {
       
        let segment = CustomSegmentedControll()
        segment.initViews()
        return segment
    }()
    
    private lazy var singUpButton: UIButton = {
       
        let singUpButton = CustomButtonWithBackground(type: .system)
        singUpButton.initViews(buttonText: "Sing Up")
        singUpButton.onAction = { success in
            print(self.emailTextField.text!)
            print(self.fullnameTextField.text!)
            print(self.passwordTextField.text!)
        }
        return singUpButton
        
    }()
    
    private lazy var alreadyHaveAnAccount: CustomQuestionButton = {
       
        let alreadyHaveAnAccount = CustomQuestionButton(type: .system)
        alreadyHaveAnAccount.initViews(questionText: "Already have an account? ", buttonText: "Sign In")
        alreadyHaveAnAccount.onAction = { _ in
            print("Sign In")
            self.navigationController?.popViewController(animated: true)
        }
        return alreadyHaveAnAccount
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        initSetups()
        initConstraints()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }

    func initSetups(){
        view.addSubview(titleLabel)
        view.addSubview(emailContainerView)
        view.addSubview(fullnameContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(segmentedControll)
        view.addSubview(singUpButton)
        view.addSubview(alreadyHaveAnAccount)
    }
    
    func initConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
        }
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.height.equalTo(34)
            make.width.equalTo(view.snp.width).offset(-32)
        }
        
        fullnameContainerView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailContainerView.snp.bottom).offset(40)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(34)
        }
        
        passwordContainerView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(fullnameContainerView.snp.bottom).offset(40)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(34)
        }
        
        segmentedControll.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(60)
        }
        
        singUpButton.snp.makeConstraints { make in
            make.top.equalTo(segmentedControll.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(52)
            
        }
        
        alreadyHaveAnAccount.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
}

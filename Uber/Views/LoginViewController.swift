//
//  LoginViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 02/11/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    struct User {
        var email: String = ""
        var password: String = ""
    }
    
    var user = User()
    
    var customTF = CustomTextField()
    
    //MARK: - Variables
    
    private lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.text = "UBER"
        titleLabel.textColor = UIColor.white
        titleLabel.font = .systemFont(ofSize: 36)
        return titleLabel
        
    }()
    
    private lazy var emailContainerView: CustomTextField = {
        
        let emailContainerView = CustomTextField()
        emailContainerView.initViews(image: "envelope",
                                     placeholder: "Email",
                                     isPassword: false)
        emailContainerView.onText = { email in
            
        }
        
        return emailContainerView
        
    }()
    
    private lazy var passwordContainerView: CustomTextField = {
        
        let passwordContainerView = CustomTextField()
        passwordContainerView.initViews(image: "lock",
                                        placeholder: "Password",
                                        isPassword: true)
        passwordContainerView.onText = { password in
            self.user.password = password
        }
        return passwordContainerView
    }()
    
    private lazy var logInButton: CustomButtonWithBackground = {
        
        let logInButton = CustomButtonWithBackground(type: .system)
        logInButton.initViews(buttonText: "Log In")
        logInButton.onAction = { success in
            
        }
        return logInButton
        
    }()
    
    private lazy var dontHaveAccountButton: CustomQuestionButton = {
        
        let button = CustomQuestionButton(type: .system)
        button.initViews(questionText: "Don't have an account? ", buttonText: "Sign Up")
        button.onAction = { _ in
            print("Sign Up")
            let signUpVC = SignUpViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
        return button
    }()
    
    
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        initSetups()
        initConstraints()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    
    //MARK: - Methods
    
    private func initSetups(){
        view.addSubview(titleLabel)
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(logInButton)
        view.addSubview(dontHaveAccountButton)
    }
    
    
    
    private func initConstraints(){
        
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
        
        passwordContainerView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(emailContainerView.snp.bottom).offset(40)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(34)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(52)
            
        }
        
        dontHaveAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        
    }
    
    
    
}

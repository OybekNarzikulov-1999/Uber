//
//  LoginViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 02/11/22.
//

import UIKit
import SnapKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Variables
    
    private lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.text = "UBER"
        titleLabel.textColor = UIColor.white
        titleLabel.font = .systemFont(ofSize: 36)
        return titleLabel
        
    }()
    
    private lazy var emailContainerView: CustomUIView = {
       
        let view = CustomUIView()
        view.iconImage = "envelope"
        view.placeholder = "Email"
        view.initViews()
        return view
        
    }()
    
    private lazy var passwordContainerView: CustomUIView = {
       
        let view = CustomUIView()
        view.iconImage = "lock"
        view.placeholder = "Password"
        view.initViews()
        return view
        
    }()
    
    private lazy var logInButton: CustomButtonWithBackground = {

        let logInButton = CustomButtonWithBackground(type: .system)
        logInButton.initViews(buttonText: "Log In")
        logInButton.onAction = { _ in
            
            guard let email = self.emailContainerView.customTextField.text else {return}
            guard let password = self.passwordContainerView.customTextField.text else {return}
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: Failed to sign in user with error -> \(error.localizedDescription)")
                    return
                }
                
                self.dismiss(animated: true)
            }
            
        }
        return logInButton

    }()
    
    private lazy var dontHaveAccountButton: CustomQuestionButton = {
        
        let button = CustomQuestionButton(type: .system)
        button.initViews(questionText: "Don't have an account? ", buttonText: "Sign Up")
        button.onAction = { _ in
            DispatchQueue.main.async {
                print("Sign Up")
                let signUpVC = SignUpViewController()
                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
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
            make.top.equalTo(emailContainerView.snp.bottom).offset(40)
            make.centerX.equalTo(view)
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

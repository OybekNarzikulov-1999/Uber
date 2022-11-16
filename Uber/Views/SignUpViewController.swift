////
////  SignUpViewController.swift
////  Uber
////
////  Created by Oybek Narzikulov on 03/11/22.
////
//
import UIKit
import Firebase
import GeoFire

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let location = LocationHandler.shared.locationManager.location

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

    private lazy var fullnameContainerView: CustomUIView = {

        let view = CustomUIView()
        view.iconImage = "person"
        view.placeholder = "Fullname"
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

    private lazy var customSegmentedControl: CustomSegmentedControll = {

        let segment = CustomSegmentedControll()
        segment.initViews()
        return segment
    }()

    private lazy var singUpButton: UIButton = {

        let singUpButton = CustomButtonWithBackground(type: .system)
        singUpButton.initViews(buttonText: "Sing Up")
        singUpButton.onAction = { _ in
            
            guard let email = self.emailContainerView.customTextField.text else {return}
            guard let fullname = self.fullnameContainerView.customTextField.text else {return}
            guard let password = self.passwordContainerView.customTextField.text else {return}
            let accountTypeIndex = self.customSegmentedControl.segmentedControl.selectedSegmentIndex
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: Failed to register user with erorr \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let values: [String:Any] = ["email": email, "fullname": fullname, "accountType": accountTypeIndex]
                
                if accountTypeIndex == 1 {
                    
                    let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                    guard let location = self.location else { return }

                    geofire.setLocation(location, forKey: uid) { error in
                        
                        self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                        
                    }
                    
                }
                
                self.uploadUserDataAndShowHomeController(uid: uid, values: values)
            }
            
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        initSetups()
        initConstraints()

        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

    }
    
    // MARK: - Methods
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String:Any]){
        
        Database.database().reference().child("users").child(uid).updateChildValues(values) { error, reference in
            
            self.dismiss(animated: true)
            
        }
        
    }

    func initSetups(){
        view.addSubview(titleLabel)
        view.addSubview(emailContainerView)
        view.addSubview(fullnameContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(customSegmentedControl)
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

        customSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view.snp.width).offset(-32)
            make.height.equalTo(60)
        }

        singUpButton.snp.makeConstraints { make in
            make.top.equalTo(customSegmentedControl.snp.bottom).offset(40)
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

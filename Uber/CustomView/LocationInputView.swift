//
//  LocationInputView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 10/11/22.
//

import UIKit
import SnapKit

protocol LocationInputViewDelegate{
    func dismissLocationInputView()
    func executeSearch(query: String)
}

class LocationInputView: UIView {

    //MARK: - Properties
    
    var delegate: LocationInputViewDelegate?
    
    var user: User? {
        didSet {
            nameLabel.text = user?.name
        }
    }
    
    private lazy var arrowButton: UIButton = {
       
        let arrowButton = UIButton()
        arrowButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        arrowButton.tintColor = .black
        arrowButton.addTarget(self, action: #selector(handleBackTapped) , for: .touchUpInside)
        return arrowButton
        
    }()
    
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .darkGray
        return label
        
    }()
    
    lazy var startingLocationTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Current Location"
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        textField.isEnabled = false
        textField.font = .systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
        
    }()
    
    lazy var destinationLocationTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter a destination..."
        textField.backgroundColor = UIColor.lightGray
        textField.returnKeyType = .search
        textField.font = .systemFont(ofSize: 14)
        textField.delegate = self
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
        
    }()
    
    private lazy var startingLocationIndicatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
        
    }()
    
    private lazy var destinationIndicatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
        
    }()
    
    private lazy var linkingView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        addShadow()
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func initViews(){
        
        self.addSubview(arrowButton)
        self.addSubview(nameLabel)
        self.addSubview(startingLocationTextField)
        self.addSubview(destinationLocationTextField)
        self.addSubview(startingLocationIndicatorView)
        self.addSubview(destinationIndicatorView)
        self.addSubview(linkingView)

        arrowButton.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(44)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arrowButton)
            make.centerX.equalTo(self)
        }
        
        startingLocationTextField.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
        
        destinationLocationTextField.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(startingLocationTextField.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        
        startingLocationIndicatorView.snp.makeConstraints { make in
            
            make.centerY.equalTo(startingLocationTextField)
            make.left.equalTo(20)
            make.height.equalTo(6)
            make.width.equalTo(6)
            
        }
        
        destinationIndicatorView.snp.makeConstraints { make in
            
            make.centerY.equalTo(destinationLocationTextField)
            make.left.equalTo(20)
            make.height.equalTo(6)
            make.width.equalTo(6)
            
        }
        
        linkingView.snp.makeConstraints { make in
            make.centerX.equalTo(startingLocationIndicatorView).offset(-0.25)
            make.top.equalTo(startingLocationIndicatorView.snp.bottom).offset(4)
            make.bottom.equalTo(destinationIndicatorView.snp.top).offset(-4)
            make.width.equalTo(0.5)
        }
        
    }
    
    @objc func handleBackTapped(){
        
        delegate?.dismissLocationInputView()
        
    }
    
}

extension LocationInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let query = textField.text else {return false}
        
        delegate?.executeSearch(query: query)
        
        return true
        
    }
    
}

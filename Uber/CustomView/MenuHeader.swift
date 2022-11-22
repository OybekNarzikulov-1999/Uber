//
//  MenuHeader.swift
//  Uber
//
//  Created by Oybek Narzikulov on 22/11/22.
//

import UIKit
import SnapKit

class MenuHeader: UIView {
    
    // MARK: - Properties
    
    private var user: User
    
    
    private lazy var profileImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 32
        return imageView
        
    }()
    
    private lazy var fullnameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Oybek Narzikulov"
        label.text = user.name
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
        
    }()
    
    private lazy var emailLabel: UILabel = {
        
        let label = UILabel()
        label.text = "123@gmail.com"
        label.text = user.email
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
        
    }()
    
    private lazy var stackView: UIStackView = {
       
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        return stack
        
    }()
    
    
    // MARK: - Lifecycle

    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        backgroundColor = .black
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helper Methods
    
    func initViews(){
        
        self.addSubview(profileImageView)
        self.addSubview(stackView)
        
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(-60)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.height.width.equalTo(64)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
    }
    
}

//
//  RideActivationView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 15/11/22.
//

import UIKit
import SnapKit
import MapKit

class RideActivationView: UIView {
    
    // MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet {
            addressTitle.text = destination?.name
            addressDescription.text = destination?.address
        }
    }
    
    
    let addressTitle: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Test Address Title"
        label.textAlignment = .center
        return label
        
    }()
    
    let addressDescription: UILabel = {
       
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        label.text = "Amir Temur Street"
        label.textAlignment = .center
        return label
        
    }()
    
    private let uberXView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 60/2
        
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "X"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        return view
        
    }()
    
    private let uberXLaber: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Uber X"
        return label
        
    }()
    
    private let devider: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    
    private let confirmButton: UIButton = {
        
        let button = UIButton()
        button.setTitle( "Confirm Uber X", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        button.backgroundColor = .black
        return button
    }()
    
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func initViews(){
        
        let stackView = UIStackView(arrangedSubviews: [addressTitle, addressDescription])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        self.addSubview(stackView)
        self.addSubview(uberXView)
        self.addSubview(uberXLaber)
        self.addSubview(devider)
        self.addSubview(confirmButton)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(12)
        }
        
        uberXView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.height.equalTo(60)
        }
        
        uberXLaber.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(uberXView.snp.bottom).offset(8)
        }
        
        devider.snp.makeConstraints { make in
            make.top.equalTo(uberXLaber.snp.bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(0.75)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.height.equalTo(52)
        }
        
    }
    
    
    @objc func confirmButtonPressed(){
        print("Confirm Button pressed")
    }
    
}

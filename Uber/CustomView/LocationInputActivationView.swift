//
//  LocationInputActivationView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 09/11/22.
//

import UIKit

class LocationInputActivationView: UIView {

    //MARK: - Properties
    
    private lazy var pointView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 3
        return view
        
    }()
    
    private lazy var addresslabel: UILabel = {
        
        let label = UILabel()
        label.text = "Where to?"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
        
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        
        self.addSubview(pointView)
        self.addSubview(addresslabel)
        
        pointView.snp.makeConstraints { make in
            
            make.centerY.equalTo(self)
            make.left.equalTo(12)
            make.height.equalTo(6)
            make.width.equalTo(6)
            
        }
        
        addresslabel.snp.makeConstraints { make in
            
            make.centerY.equalTo(self)
            make.left.equalTo(pointView.snp.right).offset(20)
            
        }
        
    }
    
}

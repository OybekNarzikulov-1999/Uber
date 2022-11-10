//
//  LocationInputActivationView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 09/11/22.
//

import UIKit

protocol LocationInputActivationViewDelegate{
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {

    //MARK: - Properties
    
    var delegate: LocationInputActivationViewDelegate?
    
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
        
        addShadow()
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        
        self.addSubview(pointView)
        self.addSubview(addresslabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
        
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
    
    @objc func presentLocationInputView(){
        delegate?.presentLocationInputView()
    }
    
}

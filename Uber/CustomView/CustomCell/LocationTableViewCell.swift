//
//  LocationTableViewCell.swift
//  Uber
//
//  Created by Oybek Narzikulov on 11/11/22.
//

import UIKit
import SnapKit

class LocationTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "123 Main Street"
        return label
        
    }()
    
    lazy var addressLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "123 Main Street"
        return label
        
    }()
    
    
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func initViews(){
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(12)
        }
        
    }
    
    
}

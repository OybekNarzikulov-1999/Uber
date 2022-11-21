//
//  RideActivationView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 15/11/22.
//

import UIKit
import SnapKit
import MapKit

protocol RideActionViewDelegate {
    func uploadTrip(_ view: RideActivationView)
    func cancelTrip()
    func pickupPassenger()
    func dropOffPassenger()
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init(){
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide:
            return "CONFIRM UBERX"
        case .cancel:
            return "CANCEL RIDE"
        case .getDirections:
            return "GET DIRECTIONS"
        case .pickup:
            return "PICKUP PASSENGER"
        case .dropOff:
            return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
}


class RideActivationView: UIView {
    
    // MARK: - Properties
    
    
    var buttonAction = ButtonAction()
    
    var delegate: RideActionViewDelegate?
    
    var user: User?
    
    var config = RideActionViewConfiguration() {
        didSet{
            configureUI(withConfig: config)
        }
    }
    
    var destination: MKPlacemark? {
        didSet {
            addressTitle.text = destination?.name
            addressDescription.text = destination?.address
        }
    }
    
    
    lazy var addressTitle: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var addressDescription: UILabel = {
       
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
        
    }()
    
    private lazy var uberXView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 60/2
        
        view.addSubview(infoViewLabel)
        
        infoViewLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        return view
        
    }()
    
    private lazy var infoViewLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "X"
        return label
        
    }()
    
    private lazy var uberXLabel: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Uber X"
        return label
        
    }()
    
    private lazy var devider: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    
    private lazy var confirmButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle( "Confirm Uber X", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18)
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
        self.addSubview(uberXLabel)
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
        
        uberXLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(uberXView.snp.bottom).offset(8)
        }
        
        devider.snp.makeConstraints { make in
            make.top.equalTo(uberXLabel.snp.bottom).offset(8)
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
        
        switch buttonAction {
        case .requestRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirections:
            print("DEBUG: Handle Get Direction...")
        case .pickup:
            delegate?.pickupPassenger()
        case .dropOff:
            delegate?.dropOffPassenger()
        }
        
    }
    
    //MARK: - Helper Methods
    
    private func configureUI(withConfig config: RideActionViewConfiguration){
        switch config {
        case .requestRide:
            
            buttonAction = .requestRide
            confirmButton.setTitle(buttonAction.description, for: .normal)
            
        case .tripAccepted:
            
            guard let user = user else {return}
            
            if user.accountType == .pessenger {
                addressTitle.text = "En Route To Passenger"
                buttonAction = .getDirections
                confirmButton.setTitle(buttonAction.description, for: .normal)
            } else {
                addressTitle.text = "Driver En Route"
                buttonAction = .cancel
                confirmButton.setTitle(buttonAction.description, for: .normal)
                addressDescription.text = nil
            }
            
            infoViewLabel.text = String(user.name.first ?? "X")
            uberXLabel.text = user.name
            
        case .driverArrived:
            guard let user = user else {return}
            
            if user.accountType == .driver {
                addressTitle.text = "Driver has arrived"
                addressDescription.text = "Please meet driver at pickup location"
                confirmButton.setTitle("Trip in Progress", for: .normal)
                confirmButton.isEnabled = false
            }
            
        case .pickupPassenger:
            addressTitle.text = "Arrived at Passenger Location"
            buttonAction = .pickup
            confirmButton.setTitle(buttonAction.description, for: .normal)
        case .tripInProgress:
            
            guard let user = user else {return}
            
            if user.accountType == .driver {
                confirmButton.setTitle("TRIP IN PROGRESS", for: .normal)
                confirmButton.isEnabled = false
            } else {
                buttonAction = .getDirections
                confirmButton.setTitle(buttonAction.description, for: .normal)
            }
            
            addressTitle.text = "En Route to Destination"
            
        case .endTrip:
            
            guard let user = user else {return}
            
            if user.accountType == .driver {
                confirmButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
                confirmButton.isEnabled = false
            } else {
                buttonAction = .dropOff
                confirmButton.setTitle(buttonAction.description, for: .normal)
            }
            
    
        }
    }
}

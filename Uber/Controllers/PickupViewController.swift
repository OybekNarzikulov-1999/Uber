//
//  PickupViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 16/11/22.
//

import UIKit
import MapKit
import SnapKit


protocol PickupViewControllerDelegate {
    
    func didAcceptTrip(_ trip: Trip)
    
}


class PickupViewController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: PickupViewControllerDelegate?
    
    let trip: Trip
    
    private lazy var dismissButton: UIButton = {
       
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var mapView: MKMapView = {
    
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 135
        return mapView
        
    }()
    
    private lazy var pickupLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Would you like to pick up this passenger?"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
        
    }()
    
    private lazy var acceptTripButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("ACCEPT TRIP", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(acceptTripButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    
    //MARK: - Lifecycle
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        initViews()
        initConstraints()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Methods
    
    func initViews(){
        view.addSubview(dismissButton)
        view.addSubview(mapView)
        view.addSubview(pickupLabel)
        view.addSubview(acceptTripButton)
        configureMapView()
    }
    
    func initConstraints(){
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(12)
            make.height.width.equalTo(18)
        }
        
        mapView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-200)
            make.height.width.equalTo(270)
        }
        
        pickupLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(mapView.snp.bottom).offset(60)
        }
        
        acceptTripButton.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(pickupLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
    }
    
    func configureMapView(){
        
        let region = MKCoordinateRegion(center: trip.pickupCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        mapView.addAnnotationAndSelect(forCoordinate: trip.pickupCoordinate)
        
    }
    
    //MARK: - Selectors
    
    @objc func cancelButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func acceptTripButtonPressed(){
        DriverService.shared.acceptTrip(trip: trip) { error, ref in
            self.delegate?.didAcceptTrip(self.trip)
        }
    }
    
    
    //MARK: - API

}

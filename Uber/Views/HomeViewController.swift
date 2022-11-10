//
//  HomeViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 09/11/22.
//

import UIKit
import Firebase
import SnapKit
import MapKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var mapView = MKMapView()
    
    private lazy var locationManager = CLLocationManager()
    
    private lazy var inputActivationView = LocationInputActivationView()
    
    private lazy var locationInputView = LocationInputView()
    
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        initViews()
        initConstraints()
        enableLocationServices()
    }

    
    //MARK: - Methods
    
    func initViews(){
        
        inputActivationView.delegate = self
        locationInputView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(inputActivationView)
        
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.inputActivationView.alpha = 1
        }
        
        view.addSubview(locationInputView)
        locationInputView.alpha = 0
        
    }
    
    func initConstraints(){
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        inputActivationView.snp.makeConstraints { make in
            
            make.centerX.equalTo(view)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).offset(-64)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            
        }
        
        locationInputView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(200)
        }
        
        
        
    }
    
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    func signOut(){
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func enableLocationServices(){
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus(){
            
        case .notDetermined:
            print("Not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("Auth Always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Auth when in use")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
        
    }
    
}

//MARK: - LocationInputActivationViewDelegate

extension HomeViewController: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("Table view starts appear")
        }
    }
    
}


//MARK: - LocationInputViewDelegate

extension HomeViewController: LocationInputViewDelegate {
    func dismissLocationInputView(){
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
        } completion: { _ in
            self.inputActivationView.alpha = 1
        }

    }
}

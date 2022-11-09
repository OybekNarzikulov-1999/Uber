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
        view.addSubview(mapView)
        view.addSubview(inputActivationView)
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

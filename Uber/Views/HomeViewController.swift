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

private let LocationCellID = "LocationTableViewCell"

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var mapView = MKMapView()
    
    private lazy var locationManager = LocationHandler.shared.locationManager
    
    private lazy var inputActivationView = LocationInputActivationView()
    
    private lazy var locationInputView = LocationInputView()
    
    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    
    private lazy var tableView: UITableView = {
       
        let tableView = UITableView()
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationCellID)
        tableView.rowHeight = 60
        tableView.allowsSelection = false
        return tableView
        
    }()
    
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        initViews()
        initConstraints()
        enableLocationServices()
        fetchUserData()
        signOut()
        
    }

    
    //MARK: - Methods
    
    func initViews(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        inputActivationView.delegate = self
        locationInputView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(inputActivationView)
        view.addSubview(tableView)
        
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
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(view.snp.height).offset(-200)
        }
        
    }
    
    func fetchUserData(){
        Service.shared.fetchUserData { user in
            self.user = user
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
            
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
            
        } catch {
            print("Error signing out")
        }
    }
}

extension HomeViewController {
    
    func enableLocationServices(){
        
        switch CLLocationManager.authorizationStatus(){
            
        case .notDetermined:
            print("Not determined")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("Auth Always")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Auth when in use")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        
    }
    
}

//MARK: - LocationInputActivationViewDelegate

extension HomeViewController: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("TextField starts appear")
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = 200
            } completion: { _ in
                print("table view appears")
            }
            
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

        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.origin.y = self.view.frame.height
        }
        
    }
}


// MARK: - TableView DataSource and Delegate Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCellID, for: indexPath) as! LocationTableViewCell
        
        return cell
        
    }
    
}

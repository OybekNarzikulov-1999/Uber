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
private let annotationIdentifier = "AnnotationID"
private enum actionButtonConfiguration {
    case showMenu
    case dismissActionButton
    
    init() {
        self = .showMenu
    }
    
}

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var mapView = MKMapView()
    
    private lazy var locationManager = LocationHandler.shared.locationManager
    
    private lazy var inputActivationView = LocationInputActivationView()
    
    private lazy var locationInputView = LocationInputView()
    
    private var actionButtonConfig = actionButtonConfiguration()
    
    private lazy var actionButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "hamburger")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    private var searchResults = [MKPlacemark]()
    
    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationCellID)
        tableView.rowHeight = 60
        tableView.allowsSelection = true
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
        fetchDrivers()
        
    }
    
    
    //MARK: - Methods
    
    func initViews(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        inputActivationView.delegate = self
        locationInputView.delegate = self
        mapView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(inputActivationView)
        view.addSubview(tableView)
        view.addSubview(actionButton)
        
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
            make.top.equalTo(actionButton.snp.bottom).offset(28)
            
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
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(20)
            make.width.equalTo(27)
            make.height.equalTo(30)
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed(){
        
        switch actionButtonConfig {
        case .showMenu:
            print("Show menu")
        case .dismissActionButton:
            
            mapView.annotations.forEach { annotation in
                if let anno = annotation as? MKPointAnnotation {
                    mapView.removeAnnotation(anno)
                }
            }
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
                
            }
            
        }
        
    }
    
    // MARK: - Helper Methods
    
    fileprivate func configureActionButton(config: actionButtonConfiguration){
        
        switch config {
            
        case .showMenu:
            
            self.actionButton.setImage(UIImage(named: "hamburger")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
            
        case .dismissActionButton:
            
            actionButton.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionButton
            
        }
    }
    
    
    func fetchDrivers(){
        guard let location = locationManager?.location else {return}
        Service.shared.fetchDrivers(location: location) { driver in
            guard let coordinate = driver.location?.coordinate else {return}
            let driverAnnotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                
                return self.mapView.annotations.contains { annotation -> Bool in
                    guard let driverAnno = annotation as? DriverAnnotation else {return false}
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    return false
                }
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(driverAnnotation)
            }
        }
        
    }
    
    func fetchUserData(){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: currentUid) { user in
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
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        }, completion: completion)
        
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

// MARK: - Map Helper Methods

private extension HomeViewController {
    
    func searchBy(naturalLanguageQuery: String, complition: @escaping([MKPlacemark]) -> Void){
        
        var result = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let respone = response else {return}
            
            response?.mapItems.forEach({ items in
                result.append(items.placemark)
            })
            
            complition(result)
            
        }
        
    }
    
}


// MARK: - Map View Delegate

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? DriverAnnotation {
            
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = UIImage(named: "joker")
            view.setDimensions(height: 35, width: 35)
            return view
            
        }
        
        return nil
    }
    
}


//MARK: - LocationInputActivationViewDelegate

extension HomeViewController: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = 200
            } completion: { _ in
            }
            
        }
    }
    
}


//MARK: - LocationInputViewDelegate

extension HomeViewController: LocationInputViewDelegate {
    
    func executeSearch(query: String) {
        self.searchBy(naturalLanguageQuery: query) { result in
            self.searchResults = result
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView(){
        
        dismissLocationView { _ in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
        
    }
}


// MARK: - TableView DataSource and Delegate Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCellID, for: indexPath) as! LocationTableViewCell
        
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlacemark = searchResults[indexPath.row]
        
        configureActionButton(config: .dismissActionButton)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismissLocationView { _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
    }
    
}

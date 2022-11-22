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

private enum AnnotationType: String {
    case pickup
    case destination
}

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var mapView = MKMapView()
    
    private lazy var locationManager = LocationHandler.shared.locationManager
    
    private lazy var inputActivationView = LocationInputActivationView()
    
    private lazy var locationInputView = LocationInputView()
    
    private var actionButtonConfig = actionButtonConfiguration()
    
    private lazy var rideActionView = RideActivationView()
    
    private var route: MKRoute?
    
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
            if user?.accountType == .pessenger {
                fetchDrivers()
                configureLocationInputActivationView()
                observeCurrentTrip()
            } else {
                observeTrips()
            }
        }
    }
    
    private var trip: Trip? {
        didSet {
            guard let user = user else {return}
            if user.accountType == .driver {
                guard let trip = trip else {return}
                let controller = PickupViewController(trip: trip)
                controller.delegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            } else {
                print("DEBUG: Show ride action view for accepted trip...")
            }
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
        
    }
    
    
    //MARK: - Methods
    
    func initViews(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationInputView.delegate = self
        mapView.delegate = self
        rideActionView.delegate = self
        
        view.addSubview(mapView)
        
        view.addSubview(tableView)
        view.addSubview(actionButton)
        view.addSubview(rideActionView)
        
        
        
        view.addSubview(locationInputView)
        locationInputView.alpha = 0
        
    }
    
    func initConstraints(){
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
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
        
        rideActionView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(300)
        }
        
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed(){
        
        switch actionButtonConfig {
        case .showMenu:
            print("Show menu")
        case .dismissActionButton:
            
            removeAnnotationsAndOverlayers()
            mapView.showAnnotations(mapView.annotations, animated: true)
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
                self.presentRideActionView(shouldShow: false)
                
            }
        }
        
    }
    
    // MARK: - Helper Methods
    
    func configureLocationInputActivationView(){
        
        inputActivationView.delegate = self
        view.addSubview(inputActivationView)
        
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.inputActivationView.alpha = 1
        }
        
        inputActivationView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).offset(-64)
            make.height.equalTo(50)
            make.top.equalTo(actionButton.snp.bottom).offset(28)
        }
        
    }
    
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
    
    // MARK: - Passenger API

    // This method observes for user
    func observeCurrentTrip(){
        PassengerService.shared.observeCurrentTrip { trip in
            self.trip = trip
            guard let state = trip.state else {return}
            guard let driverUid = trip.driverUid else {return}
            
            switch state {
            case .requested:
                break
            case .accepted:
                self.shouldPresentLoadingView(false)
                self.removeAnnotationsAndOverlayers()
                
                self.zoomForActiveTrip(withDriverUid: driverUid)
                
                Service.shared.fetchUserData(uid: driverUid) { driver in
                    self.presentRideActionView(shouldShow: true, config: .tripAccepted, user: driver)
                }
            case .driverArrived:
                self.rideActionView.config = .driverArrived
            case .inprogress:
                self.rideActionView.config = .tripInProgress
            case .arrivedAtDestination:
                self.rideActionView.config = .endTrip
            case .completed:
                PassengerService.shared.deleteTrip { error, ref in
                    self.presentRideActionView(shouldShow: false)
                    self.centerMapOnUserLocation()
                    self.configureActionButton(config: .showMenu)
                    self.inputActivationView.alpha = 1
                    self.presentAlertController(withTitle: "Trip Completed", message: "We hope you enjoyed you'r trip")
                }
            }
        }
    }
    
    func fetchDrivers(){
        
        guard let location = locationManager?.location else {return}
        PassengerService.shared.fetchDrivers(location: location) { driver in
            guard let coordinate = driver.location?.coordinate else {return}
            let driverAnnotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                
                return self.mapView.annotations.contains { annotation -> Bool in
                    guard let driverAnno = annotation as? DriverAnnotation else {return false}
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        self.zoomForActiveTrip(withDriverUid: driver.uid)
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
    
    func startTrip(){
        guard let trip = trip else {return}
        DriverService.shared.updateTripState(trip: trip, state: .inprogress) { error, ref in
            
            self.rideActionView.config = .tripInProgress
            self.removeAnnotationsAndOverlayers()
            self.mapView.addAnnotationAndSelect(forCoordinate: trip.destinationCoordinate)
            
            let placemark = MKPlacemark(coordinate: trip.destinationCoordinate)
            let mapItem = MKMapItem(placemark: placemark)
            self.generatePolyline(toDestination: mapItem)
            
            self.setCustomRegion(withType: .destination, coordinates: trip.destinationCoordinate)
            
            self.mapView.zoomToFit(annotations: self.mapView.annotations)
            
        }
    }
    
    // MARK: - Drivers API
    
    func observeTrips(){
        DriverService.shared.observeTrips { trip in
            self.trip = trip
        }
    }
    
    func observeCancelledTrip(trip: Trip){
        DriverService.shared.observeTripCancelled(trip: trip) {
            self.presentAlertController(withTitle: "Oops!", message: "Passenger has decided to cancel this ride. Press OK to continue...")
            self.removeAnnotationsAndOverlayers()
            self.presentRideActionView(shouldShow: false)
            self.centerMapOnUserLocation()
        }
    }
    
    // MARK: - Shared API
    
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
    
    // MARK: - Helper Methods
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        }, completion: completion)
        
    }
    
    func presentRideActionView(shouldShow: Bool, destination: MKPlacemark? = nil, config: RideActionViewConfiguration? = nil, user: User? = nil){
        
        if shouldShow == true {
            UIView.animate(withDuration: 0.3) {
                self.rideActionView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom).offset(-300)
                }
            }
            
            guard let config = config else {return}
            
            if let destination = destination {
                rideActionView.destination = destination
            }
            
            if let user = user {
                rideActionView.user = user
            }
            
            rideActionView.config = config
            
        } else if shouldShow == false {
            
            UIView.animate(withDuration: 0.3) {
                self.rideActionView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom)
                }
            }
            
        }
        
    }
    
}

//MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        if region.identifier == AnnotationType.pickup.rawValue {
            print("DEBUG: Did start monitoring pick up region \(region)")
        }
        
        if region.identifier == AnnotationType.destination.rawValue {
            print("DEBUG: Did start monitoring destination region \(region)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let trip = trip else {return}
        
        if region.identifier == AnnotationType.pickup.rawValue {
            DriverService.shared.updateTripState(trip: trip, state: .driverArrived) { error, ref in
                self.rideActionView.config = .pickupPassenger
            }
        }
        
        if region.identifier == AnnotationType.destination.rawValue {
            print("DEBUG: Did start monitoring destination region \(region)")
            DriverService.shared.updateTripState(trip: trip, state: .arrivedAtDestination) { error, ref in
                self.rideActionView.config = .endTrip
            }
        }
    }
    
    func enableLocationServices(){
        
        self.locationManager?.delegate = self
        
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

// MARK: - MapView Helper Methods

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
    
    func generatePolyline(toDestination destination: MKMapItem){
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { response, error in
            guard let response = response else {return}
            self.route = response.routes[0]
            guard let polyline = self.route?.polyline else {return}
            self.mapView.addOverlay(polyline)
        }
    }
    
    func removeAnnotationsAndOverlayers(){
        
        mapView.annotations.forEach { annotation in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            
            mapView.removeOverlay(mapView.overlays[0])
            
        }
    }
    
    func centerMapOnUserLocation(){
        
        guard let coordinate = locationManager?.location?.coordinate else {return}
        
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 2000,
                                        longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
        
    }
    
    func setCustomRegion(withType type: AnnotationType, coordinates: CLLocationCoordinate2D){
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        locationManager?.startMonitoring(for: region)
        
    }
    
    func zoomForActiveTrip(withDriverUid uid: String){
        var annotations = [MKAnnotation]()
        
        self.mapView.annotations.forEach { annotation in
            
            if let anno = annotation as? DriverAnnotation {
                if anno.uid == uid {
                    annotations.append(anno)
                }
            }
            
            if let anno = annotation as? MKUserLocation {
                annotations.append(anno)
            }
        }
        
        self.mapView.zoomToFit(annotations: annotations)
    }
    
}


// MARK: - Map View Delegate

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let user = user else {return}
        guard user.accountType == .driver else {return}
        guard let location = userLocation.location else {return}
        DriverService.shared.updateDriverLocation(location: location)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = UIImage(named: "joker")
            view.setDimensions(height: 35, width: 35)
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .systemBlue
            lineRenderer.lineWidth = 4
            return lineRenderer
        }
        return MKOverlayRenderer()
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
        
        let destination = MKMapItem(placemark: selectedPlacemark)
        generatePolyline(toDestination: destination)
        
        configureActionButton(config: .dismissActionButton)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismissLocationView { _ in
            
            self.mapView.addAnnotationAndSelect(forCoordinate: selectedPlacemark.coordinate)
            
            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            
            self.mapView.zoomToFit(annotations: annotations)
            
            self.presentRideActionView(shouldShow: true, destination: selectedPlacemark, config: .requestRide)
        }
    }
    
}

// MARK: - RideActionViewDelegate

extension HomeViewController: RideActionViewDelegate {
    
    func uploadTrip(_ view: RideActivationView) {
        
        guard let pickupCoordinates = locationManager?.location?.coordinate else {return}
        guard let destinationCoordinates = view.destination?.coordinate else {return}
        
        shouldPresentLoadingView(true, message: "Finding you a ride...")
        
        PassengerService.shared.uploadTrip(pickupCoordinates, destinationCoordinates: destinationCoordinates) { error, ref in
            if let error = error {
                print("Error while uploading a trip to the database\(error.localizedDescription)")
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                self.rideActionView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.snp.bottom)
                }
            }
            
        }
    }
    
    func cancelTrip() {
        
        PassengerService.shared.deleteTrip { error, ref in
            if let error = error {
                print("Erorr while deleting data from database\(error.localizedDescription)")
                return
            }
            
            self.centerMapOnUserLocation()
            self.presentRideActionView(shouldShow: false)
            self.removeAnnotationsAndOverlayers()
            self.actionButton.setImage(UIImage(named: "hamburger")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
            self.inputActivationView.alpha = 1
            
        }
        
    }
    
    func pickupPassenger() {
        startTrip()
    }
    
    func dropOffPassenger() {
        guard let trip = self.trip else {return}
        DriverService.shared.updateTripState(trip: trip, state: .completed) { error, ref in
            self.removeAnnotationsAndOverlayers()
            self.centerMapOnUserLocation()
            self.presentRideActionView(shouldShow: false)
        }
    }
}

// MARK: - PickupViewControllerDelegate

extension HomeViewController: PickupViewControllerDelegate {
    
    func didAcceptTrip(_ trip: Trip) {
        self.trip = trip
        
        self.mapView.addAnnotationAndSelect(forCoordinate: trip.pickupCoordinate)
        
        self.setCustomRegion(withType: .pickup, coordinates: trip.pickupCoordinate)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: mapItem)
        mapView.zoomToFit(annotations: mapView.annotations)
        
       observeCancelledTrip(trip: trip)
        
        self.dismiss(animated: true) {
            Service.shared.fetchUserData(uid: trip.pessengerUid) { passenger in
                self.presentRideActionView(shouldShow: true, config: .tripAccepted, user: passenger)
            }
        }
    }
    
}

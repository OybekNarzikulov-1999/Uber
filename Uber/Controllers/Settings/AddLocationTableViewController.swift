//
//  AddLocationTableViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 24/11/22.
//

import UIKit
import MapKit

private let reuseID = "Cell"

protocol AddLocationTableViewControllerDelegate {
    func updateLocation(locationString: String, type: LocationType)
}

class AddLocationTableViewController: UITableViewController {

    
    // MARK: - Properties
    
    let searchBar = UISearchBar()
    private let searchCompleter = MKLocalSearchCompleter()
    
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let type: LocationType
    private let location: CLLocation
    
    var delegate: AddLocationTableViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    init(type: LocationType, location: CLLocation) {
        self.type = type
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureSearchBar()
        configureSearchCompleter()
        
    }
    
    
    // MARK: - Helper Methods
    
    func configureTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.rowHeight = 60
        tableView.addShadow()
    }
    
    
    func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.barStyle = .black
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureSearchCompleter(){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchCompleter.region = region
        searchCompleter.delegate = self
    }

}

// MARK: - Table View Datasource/Delegate

extension AddLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let title = result.title
        let subtitle = result.subtitle
        let locationString = title + " " + subtitle
        let trimmedLocation = locationString.replacingOccurrences(of: ", United States", with: "")
        delegate?.updateLocation(locationString: trimmedLocation, type: type)
    }
    
}

// MARK: - UISearchBarDelegate

extension AddLocationTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
}


// MARK: - MKLocalSearchCompleterDelegate

extension AddLocationTableViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = searchCompleter.results
    }
    
}

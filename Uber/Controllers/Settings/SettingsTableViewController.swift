//
//  SettingsTableViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 22/11/22.
//

import UIKit

private let reuseIdentifier = "LocationCell"

enum LocationType: Int, CaseIterable, CustomStringConvertible {
    
    case home
    case work
    
    var description: String {
        switch self {
        case .home: return "Home"
        case .work: return "Work"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "Add home"
        case .work: return "Add work"
        }
    }
    
}

protocol SettingsTableViewControllerDelegate {
    func updateUser(_ controller: SettingsTableViewController)
}

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties
    
    var user: User
    private let locationManager = LocationHandler.shared.locationManager
    var delegate: SettingsTableViewControllerDelegate? 
    
    private lazy var infoHeaderView: UserInfoHeardView = {
       
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let view = UserInfoHeardView(user: user, frame: frame)
        return view
        
    }()
    
    // MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .black, tintColor: .white, title: "Settings", preferredLargeTitle: true)
        
    }
    
    
    // MARK: - Selectors
    
    @objc func handleDismissal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Methods
    
    func locationText(forType type: LocationType) -> String {
        
        switch type {
        case .home:
            return user.homeLocation ?? type.subtitle
        case .work:
            return user.workLocation ?? type.subtitle
        }
        
    }
    
    
    func configureTableView(){
        tableView.rowHeight = 60
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.tableHeaderView = infoHeaderView
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barTintColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }

}


// MARK: - Table View Delegate and DataSource

extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Favourites"
        label.textColor = .white
        
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(16)
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationTableViewCell
        
        guard let type = LocationType(rawValue: indexPath.row) else {return cell}
        cell.titleLabel.text = type.description
        cell.addressLabel.text = locationText(forType: type)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = LocationType(rawValue: indexPath.row) else {return}
        guard let location = locationManager?.location else {return}
        let controller = AddLocationTableViewController(type: type, location: location)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
    
}

extension SettingsTableViewController: AddLocationTableViewControllerDelegate {
    
    func updateLocation(locationString: String, type: LocationType) {
        PassengerService.shared.saveLocation(locationString: locationString, type: type) { error, ref in
            self.dismiss(animated: true, completion: nil)
            
            switch type {
            case .home:
                self.user.homeLocation = locationString
            case .work:
                self.user.workLocation = locationString
            }
            
            self.delegate?.updateUser(self)
            
            self.tableView.reloadData()
        }
    }
    
}

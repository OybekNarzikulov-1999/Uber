//
//  MenuTableViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 22/11/22.
//

import UIKit

private let reuseIdentifier = "MenuCell"

enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case yourTrips
    case settings
    case logOut
    
    var description: String {
        switch self {
        case .yourTrips: return "Your Trips"
        case .settings: return "Settings"
        case .logOut: return "Log Out"
        }
    }
    
}

protocol MenuTableViewControllerDelegate {
    func didSelect(option: MenuOptions)
}

class MenuTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    var delegate: MenuTableViewControllerDelegate?
    
    private lazy var menuHeader: MenuHeader = {
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 220)
        
        let view = MenuHeader(user: user, frame: frame)
        return view
    }()
    
    private lazy var blackView = UIView()
    
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
    }
    
    // MARK: - Helper Methods
    
    func configureTableView(){
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
        
    }

}


// MARK: - Table View Delegate and DataSource

extension MenuTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let option = MenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.textLabel?.text = option.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else {return}
        delegate?.didSelect(option: option)
    }
    
}

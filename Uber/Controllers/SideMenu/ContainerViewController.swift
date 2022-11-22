//
//  ContainerViewController.swift
//  Uber
//
//  Created by Oybek Narzikulov on 22/11/22.
//

import UIKit
import SnapKit
import Firebase

class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeController = HomeViewController()
    private var menuController: MenuTableViewController!
    private var isExpanded = false
    
    private lazy var blackView = UIView()
    
    private var user: User? {
        didSet{
            
            guard let user = user else {return}
            homeController.user = user
            configureMenuController(withUser: user)
            
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureHomeController()
        fetchUserData()
        checkIfUserIsLoggedIn()
        configureBlackView()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - Selectors
    
    @objc func dismissMenu(){
        isExpanded = false
        animateMenu(shouldExpand: isExpanded, completion: nil)
    }
    
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    func fetchUserData(){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
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
    
    
    // MARK: - Helper Functions

    func configureHomeController(){
        addChild(homeController)
        homeController.didMove(toParent: self)
        view.addSubview(homeController.view)
        homeController.delegate = self
    }
    
    func configureMenuController(withUser user: User){
        menuController = MenuTableViewController(user: user)
        menuController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
        menuController.delegate = self
    }
    
    func configureBlackView(){
        self.blackView.frame = CGRect(x: self.view.frame.width - 80, y: 0, width: 80, height: self.view.frame.height)
        self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil){
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.view.frame.width - 80
                self.blackView.alpha = 1
            }, completion: nil)
            
        } else {
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)
        }
        
        animateStatusBar()
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
}

extension ContainerViewController: HomeViewControllerDelegate {
    func handleMenuToggle() {
        
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
        
    }
}


extension ContainerViewController: MenuTableViewControllerDelegate {
    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded) { _ in
            
            switch option {
            case .yourTrips:
                break
            case .settings:
                guard let user = self.user else {return}
                let controller = SettingsTableViewController(user: user)
                let nav = UINavigationController(rootViewController: controller)
                nav.isModalInPresentation = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            case .logOut:
                
                let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
                    self.signOut()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
}

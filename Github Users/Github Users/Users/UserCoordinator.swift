//
//  UserCoordinator.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//


import Foundation
import UIKit
import UIComponent

protocol UserListCoordinatorDelegate: AnyObject {
    func showUserDetails(for user: UserListModel)
}

protocol UserDetailCoordinatorDelegate: AnyObject {
    func showRepository(name: String, url: URL, vc: UIViewController?)
}

class UserCoordinator {
    private let window: UIWindow?
    let splitViewController = UISplitViewController(style: .doubleColumn)
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    func showList() {
        let listVc = UserListViewController(viewModel: UserListViewModel())
        listVc.coordinatorDelegate =  self
        let listNavigationController = UINavigationController()
        listNavigationController.viewControllers = [listVc]
        
        let emptyDetailVC = UIViewController()
        emptyDetailVC.view.backgroundColor = .systemBackground
        
        let detailNavigationController = UINavigationController()
        detailNavigationController.viewControllers = [emptyDetailVC]
        
        splitViewController.viewControllers = [listVc, detailNavigationController]
        
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        splitViewController.show(.primary)
    }
}


//MARK: - UserListCoordinatorDelegate
extension UserCoordinator: UserListCoordinatorDelegate {
    func showUserDetails(for user: UserListModel) {
        let detailVc = UserDetailViewController(viewModel: UserDetailViewModel(user: user))
        detailVc.coordinatorDelegate = self
        let detailNavigationController = UINavigationController()
        detailNavigationController.viewControllers = [detailVc]
        splitViewController.showDetailViewController(detailNavigationController, sender: nil)
    }
}


extension UserCoordinator: UserDetailCoordinatorDelegate {
    func showRepository(name: String, url: URL, vc: UIViewController?) {
        let webViewVc = WebViewController(url: url)
        webViewVc.title = name
        vc?.navigationController?.pushViewController(webViewVc, animated: true)
    }
}
 

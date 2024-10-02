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
    private let navigationController = UINavigationController()
//    private var listVc: UserListViewController?
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    func showList() {
        let listVc = UserListViewController(viewModel: UserListViewModel())
        listVc.coordinatorDelegate =  self
        navigationController.viewControllers = [listVc]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


//MARK: - UserListCoordinatorDelegate
extension UserCoordinator: UserListCoordinatorDelegate {
    func showUserDetails(for user: UserListModel) {
        let detailVc = UserDetailViewController(viewModel: UserDetailViewModel(user: user))
        detailVc.coordinatorDelegate = self
        navigationController.pushViewController(detailVc, animated: true)
    }
}


extension UserCoordinator: UserDetailCoordinatorDelegate {
    func showRepository(name: String, url: URL, vc: UIViewController?) {
        let webViewVc = WebViewController(url: url)
        webViewVc.title = name
        vc?.navigationController?.pushViewController(webViewVc, animated: true)
    }
}
 

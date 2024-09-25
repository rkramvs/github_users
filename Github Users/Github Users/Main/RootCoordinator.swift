//
//  RootCoordinator.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import UIKit

public class RootCoordinator {
    
    private var window: UIWindow?

    public init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [UserListViewController()]
        window?.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }
}

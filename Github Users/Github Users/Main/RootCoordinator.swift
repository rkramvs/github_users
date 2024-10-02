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
    var userCoordinator: UserCoordinator?

    public init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        userCoordinator = UserCoordinator(window: window)
        userCoordinator?.showList()
    }
}

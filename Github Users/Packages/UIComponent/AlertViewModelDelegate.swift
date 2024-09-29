//
//  AlertViewModelDelegate.swift
//  Packages
//
//  Created by Ram Kumar on 25/09/24.
//

import UIKit

public protocol AlertViewModelDelegate: AnyObject {
    func showError(error: Error)
}

public extension AlertViewModelDelegate where Self: UIViewController {
    @MainActor func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}



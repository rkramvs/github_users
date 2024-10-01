//
//  UIView+Extension.swift
//  Packages
//
//  Created by Ram Kumar on 01/10/24.
//

import UIKit

public extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { self.addSubview($0) }
    }
}

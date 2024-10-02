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
    
    func fill(with subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

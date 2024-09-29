//
//  LoadingView.swift
//  Packages
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import UIKit

public class LoadingView: UIView {
    
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var label: UILabel = UILabel()
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [activityIndicator, label])
    
    public init(superView: UIView) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.isHidden = true
        self.alpha = 0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        superView.addSubview(self)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(greaterThanOrEqualTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor),
            self.topAnchor.constraint(greaterThanOrEqualTo: superView.topAnchor),
            self.bottomAnchor.constraint(lessThanOrEqualTo: superView.bottomAnchor),
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                                     
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor
    public func showLoading(with text: String = "Loading...") {
        
        self.superview?.bringSubviewToFront(self)
        self.label.text = text
        self.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    @MainActor
    public func hideLoading() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
        })
    }
}


public protocol LoadingViewModelDelegate: AnyObject {
    var loadingView: LoadingView? { get set }
}



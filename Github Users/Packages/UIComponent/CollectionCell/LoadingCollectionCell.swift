//
//  LoadingCollectionCell.swift
//  Packages
//
//  Created by Ram Kumar on 02/10/24.
//

import Foundation
import UIKit

public class LoadingCollectionCell: UICollectionViewCell {
    
    public var config: LoadingCollectionContentConfiguration?
    
    public override func updateConfiguration(using state: UICellConfigurationState) {
        automaticallyUpdatesBackgroundConfiguration = false
        let newConfig = config?.updated(for: state)
        contentConfiguration = newConfig
    }
}

public struct LoadingCollectionContentConfiguration: UIContentConfiguration, Equatable {
    
    public static func == (lhs: LoadingCollectionContentConfiguration, rhs: LoadingCollectionContentConfiguration) -> Bool {
        return  lhs.title == rhs.title
    }
    
    public func makeContentView() -> UIView & UIContentView {
        LoadingCollectionContentView(configuration: self)
    }
    public func updated(for state: UIConfigurationState) -> LoadingCollectionContentConfiguration {
        return self
    }
    
    var title: String?
    
    public init(title: String? = nil) {
        self.title = title
    }
}

class LoadingCollectionContentView: UIContentView & UIView {
    
    private var contentConfiguration: LoadingCollectionContentConfiguration
           
    public var configuration: UIContentConfiguration {
        get {
            contentConfiguration
        }
        set {
            if let config = newValue as? LoadingCollectionContentConfiguration {
                updateConfig(isFirst: false, config: config)
            }
        }
    }
    
    var titleLabel: UILabel = UILabel()
    var activity: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
  
    lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [activity, titleLabel])
    
    init(configuration: LoadingCollectionContentConfiguration) {
        self.contentConfiguration = configuration
        super.init(frame: .zero)
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 0
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = false
        activity.startAnimating()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 6
     
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
        ])
        
        updateConfig(isFirst: true, config: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConfig(isFirst: Bool, config: LoadingCollectionContentConfiguration) {
        guard isFirst || contentConfiguration != config else { return }
        self.contentConfiguration = config
        self.titleLabel.text = config.title
        
        DispatchQueue.main.async {
            self.activity.startAnimating()
        }
    }
}

//
//  RepositoryHeaderCell.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import Foundation
import UIKit
import UIComponent

class RepositoryHeaderCell: UICollectionViewListCell {
    
    public var config: RepositoryHeaderContentConfiguration?
    
    public override func updateConfiguration(using state: UICellConfigurationState) {
        automaticallyUpdatesBackgroundConfiguration = false
        let newConfig = config?.updated(for: state)
        contentConfiguration = newConfig
    }
}

public struct RepositoryHeaderContentConfiguration: UIContentConfiguration, Equatable {
    
    public static func == (lhs: RepositoryHeaderContentConfiguration, rhs: RepositoryHeaderContentConfiguration) -> Bool {
        return  lhs.title == rhs.title
    }
    
    public func makeContentView() -> UIView & UIContentView {
        RepositoryHeaderContentView(configuration: self)
    }
    public func updated(for state: UIConfigurationState) -> RepositoryHeaderContentConfiguration {
        return self
    }
    
    var title: String?
    
}

class RepositoryHeaderContentView: UIContentView & UIView {
    
    private var contentConfiguration: RepositoryHeaderContentConfiguration = RepositoryHeaderContentConfiguration()
           
    public var configuration: UIContentConfiguration {
        get {
            contentConfiguration
        }
        set {
            if let config = newValue as? RepositoryHeaderContentConfiguration {
//                updateConfig(config: config)
            }
        }
    }
    
    var titleLabel: UILabel = UILabel()
    
    lazy var filterButton: UIButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { _ in
//        self.contentConfiguration.handler?(self.copyButton)
    }))
    
    lazy var strengthButton: UIButton = UIButton()
    
    init(configuration: UIContentConfiguration) {
        super.init(frame: .zero)
    
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.image = UIImage(systemName: "ellipsis.circle")
        filterButton.configuration = config
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.tintColor = .accent
        

//        NSLayoutConstraint.activate([
//            copyButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
//            copyButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
//            copyButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
//            copyButton.trailingAnchor.constraint(lessThanOrEqualTo: strengthButton.leadingAnchor, constant: 10),
//            
//            strengthButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
//            strengthButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
//            strengthButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
//        ])
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func updateConfig(config: PasswordFieldDetailFooterContentConfiguration) {
//        guard contentConfiguration != config else { return }
//        self.contentConfiguration = config
//        
//        strengthButton.configuration?.title = config.strength.displayName
//        strengthButton.tintColor = config.strength.symbolColor
//        strengthButton.configuration?.image = UIImage(systemName: config.strength.symbolName, withConfiguration: UIImage.SymbolConfiguration(font: .footnoteRegular))
//    }
}




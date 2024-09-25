//
//  UserListCell.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import UIKit

class UserListCellContentView: UIView, UIContentView {
    
    var listContentConfig: UserListModel
    
    var configuration: UIContentConfiguration {
        get {
            return listContentConfig
        } set {
            guard let newConfiguration = newValue as? UserListModel else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    // We will work on the implementation in a short while.
    
    var nameLabel: UILabel = UILabel()
    
    init(configuration: UserListModel) {
        listContentConfig = configuration
        super.init(frame: .zero)
        
        setupViews()
        apply(isFirst: true, configuration: listContentConfig)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        layoutMargins.top = 12
        layoutMargins.bottom = 12
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.textColor = UIColor.label
        
        NSLayoutConstraint.activate([nameLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     nameLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     nameLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     nameLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
                                    ])
        
        
    }
    
    func apply(isFirst: Bool, configuration: UserListModel) {
        
        guard listContentConfig != configuration else { return }
        
        listContentConfig = configuration
        nameLabel.text = configuration.login
    }
    
}

class UserListCell: UICollectionViewListCell {
    
    var item: UserListModel = UserListModel.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

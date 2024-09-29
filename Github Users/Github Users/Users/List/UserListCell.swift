//
//  UserListCell.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import UIKit

class UserListCellContentView: UIView, UIContentView {
    
    var listContentConfig: UserListCellContentConfiguration
    
    var configuration: UIContentConfiguration {
        get {
            return listContentConfig
        } set {
            guard let newConfiguration = newValue as? UserListCellContentConfiguration else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    // We will work on the implementation in a short while.
    
    var nameLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    lazy var stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
    
    init(configuration: UserListCellContentConfiguration) {
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
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemGray
        imageView.layer.cornerRadius = 22
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.clipsToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        addSubview(stackView)
        
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     bottomAnchor,
                                     imageView.widthAnchor.constraint(equalToConstant: 44),
                                     imageView.heightAnchor.constraint(equalToConstant: 44)
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: UserListCellContentConfiguration) {
        
        guard isFirst || listContentConfig != configuration else { return }
        
        listContentConfig = configuration
        nameLabel.text = configuration.model.login
        if let data = configuration.model.avatarData {
            imageView.image = UIImage(data: data)
        }
    }
}

class UserListCell: UICollectionViewListCell {
    
    var item: UserListCellContentConfiguration = UserListCellContentConfiguration.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

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
    
    var nameLabel: UILabel = UILabel()
    var loginLabel: UILabel = UILabel()
    var bioLabel: UILabel = UILabel()
    lazy var labelStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, loginLabel, bioLabel])
    var imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    lazy var stackView = UIStackView(arrangedSubviews: [imageView, labelStackView])
    
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
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.textColor = UIColor.label
        nameLabel.numberOfLines = 0
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        loginLabel.textColor = UIColor.secondaryLabel
        loginLabel.numberOfLines = 0
        
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        bioLabel.textColor = UIColor.label
        bioLabel.numberOfLines = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemGray
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.clipsToBounds = true
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = 4
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.spacing = 8
        
        addSubview(stackView)
        
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     bottomAnchor,
                                     imageView.widthAnchor.constraint(equalToConstant: 50),
                                     imageView.heightAnchor.constraint(equalToConstant: 50)
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: UserListCellContentConfiguration) {
        
        guard isFirst || listContentConfig != configuration else { return }
        
        listContentConfig = configuration
        nameLabel.text = configuration.model.name
        nameLabel.isHidden = configuration.model.name == nil
        loginLabel.text = configuration.model.login
        bioLabel.text = configuration.model.bio?.trimmingCharacters(in: CharacterSet.newlines)
        bioLabel.isHidden = configuration.model.bio == nil
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

//
//  UserProfileCell.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import UIKit

struct UserProfileCellContentConfiguration: Hashable, Equatable, UIContentConfiguration {
    var model: UserListModel
    
    public func makeContentView() -> UIView & UIContentView {
        UserProfileCellContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> Self  {
        return self
    }
    
    static func `default`() -> Self {
        return UserProfileCellContentConfiguration(model: UserListModel(login: ""))
    }
}

class UserProfileCellContentView: UIView, UIContentView {
    var profileContentConfig: UserProfileCellContentConfiguration
    
    var configuration: UIContentConfiguration {
        get {
            return profileContentConfig
        } set {
            guard let newConfiguration = newValue as? UserProfileCellContentConfiguration else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    // We will work on the implementation in a short while.
    
    var nameLabel: UILabel = UILabel()
    var userNameLabel: UILabel = UILabel()
    var bioLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    lazy var nameStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, userNameLabel])
    lazy var imageStackView = UIStackView(arrangedSubviews: [imageView, nameStackView])
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [imageStackView, bioLabel])
    
    init(configuration: UserProfileCellContentConfiguration) {
        profileContentConfig = configuration
        super.init(frame: .zero)
        
        setupViews()
        apply(isFirst: true, configuration: profileContentConfig)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        layoutMargins.top = 12
        layoutMargins.bottom = 12
        
        backgroundColor = UIColor.systemBackground
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.textColor = UIColor.label
        nameLabel.numberOfLines = 0
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        userNameLabel.textColor = UIColor.secondaryLabel
        userNameLabel.numberOfLines = 0
        
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bioLabel.textColor = UIColor.label
        bioLabel.numberOfLines = 0
        
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .vertical
        nameStackView.distribution = .fill
        nameStackView.spacing = 3
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemGray
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.clipsToBounds = true
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fill
        imageStackView.spacing = 8
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 7
        
        addSubview(verticalStackView)
        
        let bottomAnchor = verticalStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([verticalStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     verticalStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     verticalStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     bottomAnchor,
                                     imageView.widthAnchor.constraint(equalToConstant: 70),
                                     imageView.heightAnchor.constraint(equalToConstant: 70)
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: UserProfileCellContentConfiguration) {
        
        guard isFirst || profileContentConfig != configuration else { return }
        
        profileContentConfig = configuration
        nameLabel.text = configuration.model.name
        nameLabel.isHidden = configuration.model.name == nil
        userNameLabel.text =  configuration.model.login
        bioLabel.text = configuration.model.bio
        bioLabel.isHidden = configuration.model.bio == nil
        if let data = configuration.model.avatarData {
            imageView.image = UIImage(data: data)
        }
    }
}

class UserProfileCell: UICollectionViewListCell {
    
    var item: UserProfileCellContentConfiguration = UserProfileCellContentConfiguration.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

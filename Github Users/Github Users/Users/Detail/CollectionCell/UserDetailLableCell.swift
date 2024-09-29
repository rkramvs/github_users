//
//  UserDetailLableCell.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import UIKit

class UserDetailLabelCell: UICollectionViewListCell {
    
    var item: UserDetailDisplayModel = UserDetailDisplayModel.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

class UserDetailCellContentView: UIView, UIContentView {
    var contentConfig: UserDetailDisplayModel
    
    var configuration: UIContentConfiguration {
        get {
            return contentConfig
        } set {
            guard let newConfiguration = newValue as? UserDetailDisplayModel else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    // We will work on the implementation in a short while.
    
    var textLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    lazy var imageStackView = UIStackView(arrangedSubviews: [imageView, textLabel])
    
    init(configuration: UserDetailDisplayModel) {
        contentConfig = configuration
        super.init(frame: .zero)
        
        setupViews()
        apply(isFirst: true, configuration: contentConfig)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        textLabel.textColor = UIColor.label
        textLabel.numberOfLines = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.secondaryLabel
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .callout), scale: .small)
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fill
        imageStackView.alignment =  .center
        imageStackView.spacing = 6
    
        addSubview(imageStackView)
        
        let bottomAnchor = imageStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([imageStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     imageStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     imageStackView.topAnchor.constraint(equalTo: self.topAnchor),
                                     bottomAnchor
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: UserDetailDisplayModel) {
        
        guard isFirst || contentConfig != configuration else { return }
        
        contentConfig = configuration
        if let symbolName = configuration.symbolName {
            imageView.image = UIImage(systemName: symbolName)
        }
        textLabel.attributedText =  configuration.attributeString
    }
}

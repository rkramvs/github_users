//
//  UserDetailLableCell.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import UIKit

struct UserDetailContentConfiguration: Hashable, Equatable, UIContentConfiguration {
    var symbolName: String?
    var imageName: String?
    var title: String?
    var attributedString: NSMutableAttributedString?
    var isTappable: Bool = false
    
    func makeContentView() -> any UIView & UIContentView {
        UserDetailCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> UserDetailContentConfiguration {
        self
    }
    
    static func `default`() -> Self {
        return UserDetailContentConfiguration(symbolName: nil, title: nil, attributedString: nil)
    }
}


class UserDetailLabelCell: UICollectionViewCell {
    
    var item: UserDetailContentConfiguration = UserDetailContentConfiguration.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

class UserDetailCellContentView: UIView, UIContentView {
    var contentConfig: UserDetailContentConfiguration
    
    var configuration: UIContentConfiguration {
        get {
            return contentConfig
        } set {
            guard let newConfiguration = newValue as? UserDetailContentConfiguration else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    // We will work on the implementation in a short while.
    
    var textLabel: UILabel = UILabel()
    var imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
    lazy var imageStackView = UIStackView(arrangedSubviews: [imageView, textLabel])
    
    init(configuration: UserDetailContentConfiguration) {
        contentConfig = configuration
        super.init(frame: .zero)
        setupViews()
        apply(isFirst: true, configuration: contentConfig)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        layoutMargins.top = 8
        layoutMargins.bottom = 8
        
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
        
        let bottomAnchor = imageStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([imageStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     imageStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     imageStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     bottomAnchor,
                                     imageView.widthAnchor.constraint(equalToConstant: 24),
                                     imageView.heightAnchor.constraint(equalToConstant: 24)
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: UserDetailContentConfiguration) {
        
        guard isFirst || contentConfig != configuration else { return }
        
        contentConfig = configuration
        if let symbolName = configuration.symbolName {
            imageView.image = UIImage(systemName: symbolName)
        } else if let imageName = configuration.imageName {
            imageView.image = UIImage(named: imageName)
        }
        textLabel.attributedText = configuration.attributedString
        textLabel.text = configuration.title
        
        if configuration.isTappable {
            textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            textLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
}

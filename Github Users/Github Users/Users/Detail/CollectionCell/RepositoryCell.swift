//
//  RepositoryCell.swift
//  Github Users
//
//  Created by Ram Kumar on 01/10/24.
//

import UIKit
import UIComponent

class RepositoryCell: UICollectionViewListCell {
    
    var item: RepositoryModel = RepositoryModel.default()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        automaticallyUpdatesBackgroundConfiguration = false
        // Set content configuration in order to update custom content view
        contentConfiguration = item.updated(for: state)
    }
}

class RepositoryCellContentView: UIView, UIContentView {
    var contentConfig: RepositoryModel
    
    var configuration: UIContentConfiguration {
        get {
            return contentConfig
        } set {
            guard let newConfiguration = newValue as? RepositoryModel else {
                return
            }
            apply(isFirst: false, configuration: newConfiguration)
        }
    }
    
    var nameLabel: UILabel = UILabel()
    var descLabel: UILabel = UILabel()
    lazy var nameStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, descLabel, tagStackWrapperView])
    
    lazy var tagStackView: UIStackView = UIStackView(arrangedSubviews: [watchTag, languageTag])
    var languageTag: LanguageTagView = LanguageTagView()
    var watchTag: WatchTagView = WatchTagView()
    var tagStackWrapperView: UIView = UIView()
    
    
    init(configuration: RepositoryModel) {
        contentConfig = configuration
        super.init(frame: .zero)
        
        setupViews()
        apply(isFirst: true, configuration: contentConfig)
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
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        descLabel.textColor = UIColor.label
        descLabel.numberOfLines = 0
        
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .vertical
        nameStackView.spacing = 6
        
        languageTag.translatesAutoresizingMaskIntoConstraints = false
        
        tagStackView.axis = .horizontal
        tagStackView.spacing = 16
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        tagStackWrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        tagStackWrapperView.addSubview(tagStackView)
        addSubview(nameStackView)
        
        let bottomAnchor = nameStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        bottomAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([nameStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                                     nameStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                                     nameStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                                     bottomAnchor,
                                     tagStackView.leadingAnchor.constraint(equalTo: tagStackWrapperView.leadingAnchor),
                                     tagStackView.trailingAnchor.constraint(lessThanOrEqualTo: tagStackWrapperView.trailingAnchor),
                                     tagStackView.topAnchor.constraint(equalTo: tagStackWrapperView.topAnchor),
                                     tagStackView.bottomAnchor.constraint(equalTo: tagStackWrapperView.bottomAnchor)
                                    ])
        
    }
    
    func apply(isFirst: Bool, configuration: RepositoryModel) {
        
        guard isFirst || contentConfig != configuration else { return }
        
        contentConfig = configuration
        nameLabel.text = configuration.name
        descLabel.text = configuration.description
        let colorHex = LanguageColorMObject.fetchColor(for: configuration.language, in: CoreDataHelper.shared.mainContext)
        languageTag.set(color: UIColor(hex: colorHex) , language: configuration.language)
        languageTag.isHidden = configuration.language == nil
        watchTag.set(NumberFormat.formatNumber(Double(configuration.watchers ?? 0)))
        watchTag.isHidden = configuration.watchers == nil
        tagStackWrapperView.isHidden = configuration.language == nil && configuration.watchers == nil
    }
}

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
    var selectedFilter: RepositoryFilterType?
    var handler: ((RepositoryFilterType, UIButton) -> ())?
}

class RepositoryHeaderContentView: UIContentView & UIView {
    
    private var contentConfiguration: RepositoryHeaderContentConfiguration
           
    public var configuration: UIContentConfiguration {
        get {
            contentConfiguration
        }
        set {
            if let config = newValue as? RepositoryHeaderContentConfiguration {
                updateConfig(isFirst: false, config: config)
            }
        }
    }
    
    var titleLabel: UILabel = UILabel()
    var iconView: UIImageView = UIImageView()
    lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
    
    var filterButton: UIButton = UIButton(frame: .zero)
    
    lazy var strengthButton: UIButton = UIButton()
    
    init(configuration: RepositoryHeaderContentConfiguration) {
        self.contentConfiguration = configuration
        super.init(frame: .zero)
        
        backgroundColor = UIColor.systemBackground
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 0
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = UIColor.label
        iconView.image = UIImage(systemName: "text.book.closed.fill")
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = .init(textStyle: .headline, scale: .medium)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.setPreferredSymbolConfiguration(.init(textStyle: .headline, scale: .medium), forImageIn: .normal)
        filterButton.showsMenuAsPrimaryAction = true
        
        addSubviews(stackView, filterButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            filterButton.leadingAnchor.constraint(equalTo: filterButton.trailingAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            filterButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        updateConfig(isFirst: true, config: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConfig(isFirst: Bool, config: RepositoryHeaderContentConfiguration) {
        guard isFirst || contentConfiguration != config else { return }
        self.contentConfiguration = config
        self.titleLabel.text = config.title
        var menuActions: [UIAction] = []
        for filter in RepositoryFilterType.allCases {
            menuActions.append(UIAction(title: filter.filterTitle, state: filter == config.selectedFilter ? .on : .off, handler: { _ in
                self.contentConfiguration.handler?(filter, self.filterButton)
            }))
        }
        
        let menu = UIMenu(title: "Repository", children: menuActions)
        filterButton.menu = menu
    }
}




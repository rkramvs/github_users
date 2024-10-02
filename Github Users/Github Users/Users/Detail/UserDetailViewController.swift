//
//  UserDetailViewController.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//

import Foundation
import UIKit
import UIComponent

class UserDetailViewController: UIViewController {
    
    var viewModel: UserDetailViewModel
    
    typealias Section = UserDetailViewModel.Section.SectionType
    typealias Item = UserDetailViewModel.Section.Item
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private lazy var collectionView: UICollectionView = {
        var config =  UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [self] section, environment in
            
            switch self.viewModel.sections[section].type {
            case .userProfile:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)))
                var group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .userDetails:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                ))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                ), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                return section
            case .repository:
                var config = UICollectionLayoutListConfiguration(appearance: .grouped)
                config.itemSeparatorHandler = { indexPath, configuration in
                    var _configuration = configuration
                    if indexPath.row == 0 {
                        _configuration.topSeparatorVisibility = .hidden
                    }
                    return _configuration
                }
                config.headerMode = .supplementary
                if self.viewModel.isRepositoryFetchingInProgress {
                    config.footerMode = .supplementary
                }
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
                return section
            }
           
        }, configuration: config)
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.bottom = 40
        return collectionView
    }()
    
    var loadingView: LoadingView?
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        loadingView = LoadingView(superView: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViewHierarchy()
        setupViewConstraints()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.fetchDetails()
            await viewModel.fetchRepositories()
        }
    }
    
    func setupViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        let profileCellRegistration = UICollectionView.CellRegistration<UserProfileCell, UserListModel> {(cell, indexPath, item) in
            cell.item = UserProfileCellContentConfiguration(model: item)
            
            guard let avatarUrl = item.avatarUrl, item.avatarData == nil else { return }

            ImageCache.publicCache.load(url: avatarUrl as NSURL, key: item.login) {login, image in
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    let context = CoreDataHelper.shared.bgContext
                    try? UserMObject.updateAvatarData(login: login, avatarData: data, in: context)
                }
            }
        }
        
        let userDetailCellRegistration = UICollectionView.CellRegistration<UserDetailLabelCell, UserDetailViewModel.UserDetails> {(cell, indexPath, item) in
            var bgConfig = UIBackgroundConfiguration.clear()
            bgConfig.backgroundColor = UIColor.systemBackground
            cell.backgroundConfiguration = bgConfig
            
            switch item {
            case .blog(let url):
                let configuration = UserDetailContentConfiguration(symbolName: "link",
                                                                   title: url.absoluteString,
                                                                   attributedString: nil,
                                                                   isTappable: true)
                cell.item = configuration
            case .company(let company):
                let configuration = UserDetailContentConfiguration(symbolName: "building.2",
                                                                   title: company,
                                                                   attributedString: nil)
                cell.item = configuration
            case .location(let location):
                let configuration = UserDetailContentConfiguration(symbolName: "location",
                                                                   title: location,
                                                                   attributedString: nil)
                cell.item = configuration
            case .email(let email):
                let configuration = UserDetailContentConfiguration(symbolName: "envelope",
                                                                   title: email,
                                                                   attributedString: nil,
                                                                   isTappable: true)
                cell.item = configuration
            case .twitter(let twitter):
                let configuration = UserDetailContentConfiguration(symbolName: nil,
                                                                   imageName: "twitter",
                                                                   title: twitter,
                                                                   isTappable: true)
                cell.item = configuration
            case .followers(let followersCount, let followingsCount):
                let configuration = UserDetailContentConfiguration(symbolName: "person.2.fill",
                                                                   title: "\(followersCount) followers \u{00B7} \(followingsCount) followings",
                                                                   isTappable: false)
                cell.item = configuration
            }
        }
        
        let repositoryCellRegistration = UICollectionView.CellRegistration<RepositoryCell, RepositoryModel> {(cell, indexPath, item) in
            cell.item = item
            cell.accessories = [.disclosureIndicator()]
        }
    
        let headerRegistration = UICollectionView.SupplementaryRegistration<RepositoryHeaderCell>(elementKind: UICollectionView.elementKindSectionHeader) {[weak self] header, elementKind, indexPath in
            guard let self else { return }
            var config = RepositoryHeaderContentConfiguration(title: self.viewModel.sections[indexPath.section].title)
            config.selectedFilter = viewModel.repoFilterType
            config.handler = { [weak self] filter, button in
                self?.viewModel.update(filter: filter)
            }
            header.config = config
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<LoadingCollectionCell>(elementKind: UICollectionView.elementKindSectionFooter) {footer, elementKind, indexPath in
            let config = LoadingCollectionContentConfiguration(title: "Loading...")
            footer.config = config
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {collectionView, IndexPath, item in
            switch item {
            case .userProfile:
                let cell = collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: IndexPath, item: self.viewModel.userDetailModel.listModel)
                return cell
            case .userDetails(let userDetail):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: userDetail)
                return cell
            case .repository(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: repositoryCellRegistration, for: IndexPath, item: model)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, elementKind, indexPath in
            guard let self else { return nil }
            if elementKind == UICollectionView.elementKindSectionHeader {
                let section = self.viewModel.sections[indexPath.section]
                switch section.type {
                case .repository:
                    let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
                    return header
                default:
                    return nil
                }
            } else if elementKind == UICollectionView.elementKindSectionFooter {
                let section = self.viewModel.sections[indexPath.section]
                switch section.type {
                case .repository:
                    let footer = collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
                    return footer
                default:
                    return nil
                }
            }
            return nil
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
}

//MARK: - UserDetailViewModelDelegate

extension UserDetailViewController: UserDetailViewModelDelegate {
    func reloadCollectionView(with animation: Bool) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections(viewModel.sections.map { $0.type })
        viewModel.sections.forEach{
            snapShot.appendItems($0.items, toSection: $0.type)
        }
        dataSource?.apply(snapShot, animatingDifferences: animation)
    }
}

//MARK: - UICollectionViewDelegate
extension UserDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section].items[indexPath.row] {
        case .userDetails(let userDetail):
            switch userDetail  {
            case .blog(let url):
                UIApplication.shared.open(url)
            case .email(let email):
                if let mailToURL = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(mailToURL)
                }
            case .twitter(let userName):
                if let url = TwitterURLConstructor.url(for: userName) {
                    UIApplication.shared.open(url)
                }
            default:
                break
            }
            
        case .repository(let repository):
            if let url = repository.htmlUrl {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
      
        guard offsetY > 0 else { return }
        guard contentHeight > height else { return }
        guard (contentHeight - offsetY) <= height else { return }
        guard viewModel.canLoadNextPage, !viewModel.isNextPageLoading else { return }
        loadMore()
    }
    
    func loadMore(){
        Task {
            await viewModel.fetchNextRepositories()
        }
        
    }
}


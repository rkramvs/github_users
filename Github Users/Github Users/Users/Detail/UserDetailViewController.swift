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
                section.interGroupSpacing = 10
                return section
            case .repository:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
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
        viewModel.fetchDetails()
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
        
            ImageCache.publicCache.load(url: avatarUrl as NSURL, id: item.id) {id, image in
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    let context = CoreDataHelper.shared.bgContext
                    try? UserMObject.updateAvatarData(id: id, avatarData: data, in: context)
                }
            }
        }
        
        let userDetailCellRegistration = UICollectionView.CellRegistration<UserDetailLabelCell, UserDetailDisplayModel> {(cell, indexPath, item) in
            cell.item = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {collectionView, IndexPath, item in
            
            switch item {
                
            case .userProfile:
                let cell = collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: IndexPath, item: self.viewModel.userDetailModel.listModel)
                return cell
                
            case .company(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            case .location(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            case .email(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            case .blog(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            case .twitter(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            case .followers(let model):
                let cell = collectionView.dequeueConfiguredReusableCell(using: userDetailCellRegistration, for: IndexPath, item: model)
                return cell
            }
           
        }
        
        collectionView.dataSource = dataSource
//        collectionView.delegate = self
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



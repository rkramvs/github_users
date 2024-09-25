//
//  ViewController.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import UIKit
import CoreData

class UserListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.bottom = 82
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        setupViewHierarchy()
        setupViewConstraints()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
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
        
        let cellRegistration = UICollectionView.CellRegistration<UserListCell, NSManagedObjectID> {[weak self] (cell, indexPath, item) in
            guard let self else { return }
            
            let object = self.viewModel.listFRC.object(at: indexPath)
            let model = self.viewModel.displayModel(model: object.model)
            cell.item = model
            
            cell.copyButtonHandler = {[model] in
                UIPasteboard.general.string = model.password
                Haptic.impact(.heavy).generate()
                #if !APP_EXTENSION
                AnalyticsManager.shared.logEvent(event: AnalyticsEvent.CopyPassword)
                #endif
            }
            
            cell.accessories = [.disclosureIndicator()]
        }
        
      
        
        dataSource = PasswordListDataSource(collectionView: collectionView) {collectionView, IndexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: IndexPath, item: item)
            return cell
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        try? viewModel.listFRC.performFetch()
    }
}


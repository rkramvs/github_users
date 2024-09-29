//
//  ViewController.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import UIKit
import CoreData
import UIComponent
import CoreData

class UserListViewController: UIViewController {
    
    typealias UserListDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>
    private var dataSource: UserListDataSource?
    weak var coordinatorDelegate: UserListCoordinatorDelegate?
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.bottom = 82
        return collectionView
    }()
    
    var loadingView: LoadingView?
    var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.listFRC.delegate = self
        loadingView = LoadingView(superView: self.view)
        title = "Users"
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
        view.backgroundColor = .systemBackground
        viewModel.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
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
            let model = object.listModel
            cell.item = UserListCellContentConfiguration(model: model)
            cell.accessories = [.disclosureIndicator()]
            
            guard let avatarUrl =  model.avatarUrl, model.avatarData == nil else { return }
        
            ImageCache.publicCache.load(url: avatarUrl as NSURL, id: model.id) {id, image in
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    let context = CoreDataHelper.shared.bgContext
                    try? UserMObject.updateAvatarData(id: id, avatarData: data, in: context)
                }
            }
        }
        
        dataSource = UserListDataSource(collectionView: collectionView) {collectionView, IndexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: IndexPath, item: item)
            return cell
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        try? viewModel.listFRC.performFetch()
    }
}

//MARK: - UserLisViewModelDelegate

extension UserListViewController: UserLisViewModelDelegate {
    
}

//MARK: - UICollectionViewDelegate
extension UserListViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let user = viewModel.listFRC.object(at: indexPath).listModel
       coordinatorDelegate?.showUserDetails(for: user)
    }
}

//MARK: - ScrollViewDelegate
extension UserListViewController{
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
        viewModel.loadNextPage()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension UserListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapShot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        dataSource?.apply(snapShot)
    }
}

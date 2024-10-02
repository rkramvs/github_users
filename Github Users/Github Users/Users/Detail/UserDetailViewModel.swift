//
//  UserDetailViewModel.swift
//  Github Users
//
//  Created by Ram Kumar on 29/09/24.
//


import Foundation
import UIComponent

protocol UserDetailViewModelDelegate:  LoadingViewModelDelegate, AlertViewModelDelegate {
    func reloadCollectionView(with animation: Bool)
}

class UserDetailViewModel {
    
    typealias SectionComputationHandler = () -> [Section?]
    typealias SectionConstructorDictType = [Sections: SectionComputationHandler]
    var sections: [Section] = []
    var sectionConstructor: SectionConstructorDictType = [:]
    
    weak var delegate: UserDetailViewModelDelegate?
    var isRequestInProgress: Bool = false
    
    var isRepositoryFetchingInProgress: Bool = false
    
    lazy var repositoryAPI = RepositoryAPI(login: user.login)
    var user: UserListModel
    var userDetailModel = UserDetailModel()
    var repositories: [RepositoryModel] = []
    var repoFilterType: RepositoryFilterType = .nonForked
    
    var isNextPageLoading: Bool = false
    var canLoadNextPage: Bool {
        return repositoryAPI.nextPageURL != nil
    }
    
    init(user: UserListModel) {
        self.user = user
        initiateTableSectionConstructor()
        computeTableSections()
    }
    
    var followingsFormatted: String {
        return "\(NumberFormat.formatNumber(Double(self.userDetailModel.following)))"
    }
    
    var followersFormatted: String {
        return "\(NumberFormat.formatNumber(Double(self.userDetailModel.followers)))"
    }
    
    @MainActor
    func fetchDetails() async {
        delegate?.loadingView?.showLoading()
        isRequestInProgress = true
        do {
            let userDetail = try await UserDetailAPI(login: user.login).getUserDetail()
            self.userDetailModel = userDetail
            self.userDetailModel.avatarData = self.user.avatarData
            self.computeTableSections()
            self.delegate?.reloadCollectionView(with: false)
            delegate?.loadingView?.hideLoading()
            isRequestInProgress = false
        }catch {
            delegate?.loadingView?.hideLoading()
            delegate?.showError(error: error)
            isRequestInProgress = false
        }
    }
    
    @MainActor
    func fetchRepositories() async {
        self.isRepositoryFetchingInProgress =  true
        self.computeTableSections()
        self.delegate?.reloadCollectionView(with: false)
        do {
            self.repositories = try await repositoryAPI.getRepositories(fetchType: .default).filter{!$0.fork}
            self.isRepositoryFetchingInProgress = false
            self.computeTableSections()
            self.delegate?.reloadCollectionView(with: false)
        }catch {
            self.delegate?.loadingView?.hideLoading()
            self.delegate?.showError(error: error)
            self.isRequestInProgress = false
            self.isRepositoryFetchingInProgress = false
            self.computeTableSections()
            self.delegate?.reloadCollectionView(with: false)
        }
    }
    
    @MainActor
    func fetchNextRepositories() async {
        self.isNextPageLoading = true
        self.isRepositoryFetchingInProgress =  true
        self.computeTableSections()
        self.delegate?.reloadCollectionView(with: false)
        do {
            let _repositories = try await repositoryAPI.getRepositories(fetchType: .nextPage).filter{!$0.fork}
            self.repositories.append(contentsOf: _repositories)
            self.isNextPageLoading = false
            self.isRepositoryFetchingInProgress =  false
            self.computeTableSections()
            self.delegate?.reloadCollectionView(with: false)
           
        }catch {
            self.delegate?.loadingView?.hideLoading()
            self.delegate?.showError(error: error)
            self.isRequestInProgress = false
            self.isNextPageLoading = false
            self.isRepositoryFetchingInProgress =  false
            self.computeTableSections()
            self.delegate?.reloadCollectionView(with: false)
        }
    }
    
    func update(filter: RepositoryFilterType) {
        self.repoFilterType = filter
        self.computeTableSections()
        self.delegate?.reloadCollectionView(with: true)
    }
    
    func update(avatarData: Data?) {
        self.userDetailModel.avatarData = avatarData
        self.computeTableSections()
        self.delegate?.reloadCollectionView(with: true)
    }
    
}

//MARK: - CollectionViewSection

extension UserDetailViewModel {
    
    enum UserDetails: Hashable {
        case company(String)
        case location(String)
        case email(String)
        case blog(URL)
        case twitter(String)
        case followers(_ count: String, followingsCount: String)
    }
    
    enum Sections: Int, CaseIterable, Equatable {
        case userProfile, userDetails, repository
    }
  
    struct Section: Hashable {
        
        enum SectionType: Hashable {
            case userProfile
            case userDetails
            case repository(filterType: RepositoryFilterType)
        }
        
        enum Item: Hashable {
            case userProfile
            case userDetails(UserDetails)
            case repository(RepositoryModel)
        }
        
        var type: SectionType
        var title: String?
        var items: [Item] = []
    }
    
    func computeTableSections() {
        self.sections.removeAll()
        var sections: [Sections]
        sections = Sections.allCases.sorted(by: { $0.rawValue < $1.rawValue })
        self.sections = sections.flatMap { self.sectionConstructor[$0]?() ?? [] }.compactMap{$0}
    }
    
    func initiateTableSectionConstructor() {
        sectionConstructor[.userProfile] = profileSection
        sectionConstructor[.userDetails] = userDetailSection
        sectionConstructor[.repository] = repositoriesSection
    }
    
    var profileSection: SectionComputationHandler { {
            return [Section(type: .userProfile, title: nil, items: [.userProfile])]
        }
    }
    
    var userDetailSection: SectionComputationHandler { {[unowned self] in
        
        var items: [Section.Item] = []
        
        if let company = self.userDetailModel.company {
            items.append(.userDetails(.company(company)))
        }
        
        if let location = self.userDetailModel.location {
            items.append(.userDetails(.location(location)))
        }
        
        if let email = self.userDetailModel.email {
            items.append(.userDetails(.email(email)))
        }
        
        if let blog = self.userDetailModel.blog, let url = URL(string: blog) {
            items.append(.userDetails(.blog(url)))
        }
        
        if let twitter = self.userDetailModel.twitterUsername {
            items.append(.userDetails(.twitter(twitter)))
        }

        items.append(.userDetails(.followers(followersFormatted, followingsCount: followingsFormatted)))
        
        guard !items.isEmpty else {
            return []
        }
        
        return [Section(type: .userDetails, title: nil, items: items)]
    }
    }
    
    var repositoriesSection: SectionComputationHandler { {[unowned self] in
        return [Section(type: .repository(filterType: self.repoFilterType), title: self.repoFilterType.displayText, items: self.filteredRepositories.map{.repository($0)})]
    }
    }
    
    var filteredRepositories: [RepositoryModel] {
        switch repoFilterType {
        case .allRepositories:
            return repositories
        case .nonForked:
            return repositories.filter{!$0.fork}
        case .publicRepo:
            return repositories.filter{!$0.private}
        }
    }
}

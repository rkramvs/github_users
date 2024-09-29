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
    
    var user: UserListModel
    var userDetailModel = UserDetailModel()
    
    init(user: UserListModel) {
        self.user = user
        
        initiateTableSectionConstructor()
        computeTableSections()
    }
    
    @MainActor
    func fetchDetails() {
        delegate?.loadingView?.showLoading()
        isRequestInProgress = true
        Task {
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
    }
}

//MARK: - CollectionViewSection

extension UserDetailViewModel {
    
    enum Sections: Int, CaseIterable, Equatable {
        case userProfile, userDetails, repository
    }
  
    struct Section: Hashable {
        
        enum SectionType: Hashable {
            case userProfile
            case userDetails
            case repository
        }
        
        enum Item: Hashable {
            case userProfile
            case company(UserDetailDisplayModel),
                 location(UserDetailDisplayModel),
                 email(UserDetailDisplayModel),
                 blog(UserDetailDisplayModel),
                 twitter(UserDetailDisplayModel),
                 followers(UserDetailDisplayModel)
        }
        
        var type: SectionType
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
    }
    
    var profileSection: SectionComputationHandler { {
            return [Section(type: .userProfile, items: [.userProfile])]
        }
    }
    
    var userDetailSection: SectionComputationHandler { {[unowned self] in
        
        var items: [Section.Item] = []
        
        if let company = self.userDetailModel.company {
            items.append(.company(UserDetailDisplayModel(symbolName: "building.2",
                                                         attributeString: NSMutableAttributedString(string: company))))
        }
        
        if let location = self.userDetailModel.location {
            items.append(.location(UserDetailDisplayModel(symbolName: "location",
                                                          attributeString: NSMutableAttributedString(string: location))))
        }
        
        if let email = self.userDetailModel.email {
            items.append(.email(UserDetailDisplayModel(symbolName: "envelope",
                                                          attributeString: NSMutableAttributedString(string: email))))
        }
        
        if let blog = self.userDetailModel.blog {
            items.append(.blog(UserDetailDisplayModel(symbolName: "link",
                                                          attributeString: NSMutableAttributedString(string: blog))))
        }
        
        if let twitter = self.userDetailModel.twitterUsername {
            items.append(.twitter(UserDetailDisplayModel(symbolName: "link",
                                                          attributeString: NSMutableAttributedString(string: twitter))))
        }
        
        items.append(.followers(UserDetailDisplayModel(symbolName: "person.2.fill",
                                                       attributeString: NSMutableAttributedString(string: "\(self.followersFormatted) \u{00B7} \(self.followingsFormatted)"))))
        
        guard !items.isEmpty else {
            return []
        }
        
        return [Section(type: .userDetails, items: items)]
    }
    }
    
    var followingsFormatted: String {
        return "\(NumberFormat.formatNumber(Double(self.userDetailModel.following))) following"
    }
    
    var followersFormatted: String {
        return "\(NumberFormat.formatNumber(Double(self.userDetailModel.followers))) followers"
    }
}

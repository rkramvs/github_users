//
//  UserListViewModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData
import UIComponent

protocol UserLisViewModelDelegate: LoadingViewModelDelegate, AlertViewModelDelegate, NSFetchedResultsControllerDelegate {
}

class UserListViewModel {
    var listAPI = UsersListAPI(fetchType: .default)
    var listFRC: NSFetchedResultsController<UserMObject> = UserMObject.getFRC(entity: .users)
    weak var delegate: UserLisViewModelDelegate?
    var isRequestInProgress: Bool = false
    var isNextPageLoading: Bool = false
    var searchActive: Bool = false
    
    var canLoadNextPage: Bool {
        return listAPI.hasMorePage
    }
    
    @MainActor
    func fetchUsers() {
        delegate?.loadingView?.showLoading()
        isRequestInProgress = true
        Task {
            do {
                let users = try await self.listAPI.getUsers(fetchType: .default)
                let context = CoreDataHelper.shared.mainContext
                try context.batchDelete(fetchRequest: UserMObject.fetchRequest<NSFetchRequestResult>(entity: .users), mergeTo: [context])
                try updateUsersInDB(users: users, in: .users, using: context)
                try context.save()
                delegate?.loadingView?.hideLoading()
                isRequestInProgress = false
            }catch {
                delegate?.loadingView?.hideLoading()
                delegate?.showError(error: error)
                isRequestInProgress = false
            }
        }
    }
    
    @MainActor
    func loadNextPage() {
        isNextPageLoading = true
        isRequestInProgress = true
        Task {
            do {
                let users = try await self.listAPI.getUsers(fetchType: .nextPage)
                let context = CoreDataHelper.shared.mainContext
                try updateUsersInDB(users: users, in: .users, using: context)
                try context.save()
                isNextPageLoading = false
                isRequestInProgress = false
            }catch {
                delegate?.showError(error: error)
                isNextPageLoading = false
                isRequestInProgress = false
            }
        }
    }
    
    @MainActor
    func searchUsers(_ searchText: String) {
        isRequestInProgress = true
        Task {
            do {
                let users = try await self.listAPI.getUsers(fetchType: .search(text: searchText))
                let context = CoreDataHelper.shared.mainContext
                try context.batchDelete(fetchRequest: UserMObject.fetchRequest<NSFetchRequestResult>(entity: .usersSearch), mergeTo: [context])
                try updateUsersInDB(users: users, in: .usersSearch, using: context)
                isRequestInProgress = false
                try context.save()
                
                if listFRC.fetchRequest.entityName != CoreDataEntity.usersSearch.rawValue {
                    listFRC = UserMObject.getFRC(entity: .usersSearch)
                    listFRC.delegate = delegate
                    fetchFRC() 
                }
                
            }catch {
                isRequestInProgress = false
                delegate?.showError(error: error)
            }
        }
    }
    
    private func updateUsersInDB(users: [UserListModel], in entity: CoreDataEntity, using context: NSManagedObjectContext) throws {
        for user in users {
            try UserMObject.insert(user: user, in: entity, context: context)
        }
    }
    
    func searchCancelled() {
        listFRC = UserMObject.getFRC(entity: .users)
        listFRC.delegate = delegate
        fetchFRC()
    }
    
    func fetchFRC() {
        do {
            try listFRC.performFetch()
        }catch {
            
        }
    }
}

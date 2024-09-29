//
//  UserListViewModel.swift
//  Github Users
//
//  Created by Ram Kumar on 25/09/24.
//

import Foundation
import CoreData
import UIComponent

protocol UserLisViewModelDelegate: LoadingViewModelDelegate, AlertViewModelDelegate {
}

class UserListViewModel {
    var listAPI = UsersListAPI(fetchType: .default)
    var listFRC: NSFetchedResultsController<UserMObject> = UserMObject.getFRC()
    weak var delegate: UserLisViewModelDelegate?
    var isRequestInProgress: Bool = false
    var isNextPageLoading: Bool = false
    
    var canLoadNextPage: Bool {
        return listAPI.nextPageURL != nil
    }
    
    @MainActor
    func fetchUsers() {
        delegate?.loadingView?.showLoading()
        isRequestInProgress = true
        Task {
            do {
                let users = try await self.listAPI.getUsers(fetchType: .default)
                let context = CoreDataHelper.shared.mainContext
                try context.batchDelete(fetchRequest: UserMObject.fetchRequest<NSFetchRequestResult>(), mergeTo: [context])
                try updateUsersInDB(users: users, using: context)
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
                try updateUsersInDB(users: users, using: context)
                isNextPageLoading = false
                isRequestInProgress = false
            }catch {
                delegate?.showError(error: error)
                isNextPageLoading = false
                isRequestInProgress = false
            }
        }
    }
    
    private func updateUsersInDB(users: [UserListModel], using context: NSManagedObjectContext) throws {
        for user in users {
           try UserMObject.insert(user: user, context: context)
        }
    }
}

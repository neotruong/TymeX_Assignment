//
//  CacheServceImp.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Input
    enum Input {
        case onAppear
        case loadMore
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear:
            loadCachedUsers()
            fetchUsers()
        case .loadMore:
            loadMoreUsers()
        }
    }

    // MARK: - Output
    @Published var isLoading = true
    @Published var listUsers: [User] = []
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var cancellables: Set<AnyCancellable> = []
    private let userService: NetworkProtocol
    private let cacheManager: UserCacheManager
    private var currentPage: Int = 1
    private var currentSince: Int = 0
    private let maxCacheSize = 100

    init(userService: NetworkProtocol = NetworkService(), cacheManager: UserCacheManager = UserCacheManager()) {
        self.userService = userService
        self.cacheManager = cacheManager
    }
    
    // MARK: - Load Cached Users
    private func loadCachedUsers() {
        let (cachedUsers, cachedPage, cachedSince) = cacheManager.loadCachedUsers()
        if !cachedUsers.isEmpty {
            self.listUsers = cachedUsers
            self.currentPage = cachedPage
            self.currentSince = cachedSince
            self.isLoading = false
        }
    }
    
    // MARK: - Fetch Users from API
    private func fetchUsers() {
        userService.fetchData(as: [User].self, endpoint: UserService.fetchUsers(page: currentPage, since: currentSince))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Error loading users: \(error)"
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                self.isLoading = false
                
                self.listUsers.append(contentsOf: newUsers)
                
                if self.listUsers.count <= self.maxCacheSize {
                    self.cacheManager.saveUsers(self.listUsers, page: self.currentPage, since: self.currentSince)
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Load More Users
    private func loadMoreUsers() {
        currentPage += 1
        currentSince = listUsers.last?.id ?? 0
        
        fetchUsers()
    }
}

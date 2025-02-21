//
//  CacheServceImp.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import Foundation

class UserCacheManager {
    private let cacheService: CacheServiceProtocol
    private let cacheKey = "cachedUsers"
    private let pageKey = "cachedPage"
    private let sinceKey = "cachedSince"

    init(cacheService: CacheServiceProtocol = CacheService()) {
        self.cacheService = cacheService
    }

    func saveUsers(_ users: [User], page: Int, since: Int) {
        let cachedUsers = Array(users)
        cacheService.save(cachedUsers, forKey: cacheKey)
        cacheService.save(page, forKey: pageKey)
        cacheService.save(since, forKey: sinceKey)
    }
    
    func loadCachedUsers() -> ([User], Int, Int) {
        let cachedUsers = cacheService.load(forKey: cacheKey, as: [User].self) ?? []
        let page = cacheService.load(forKey: pageKey, as: Int.self) ?? 1
        let since = cacheService.load(forKey: sinceKey, as: Int.self) ?? 0
        return (cachedUsers, page, since)
    }

    func clearCache() {
        cacheService.remove(forKey: cacheKey)
        cacheService.remove(forKey: pageKey)
        cacheService.remove(forKey: sinceKey)
    }
}

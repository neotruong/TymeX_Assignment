//
//  MockCacheService.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//

import Foundation
@testable import TymeX_Assignment

class MockCacheService: CacheServiceProtocol {
    var storage: [String: Data] = [:]

    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            storage[key] = encoded
        }
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = storage[key] else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }

    func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}

final class MockUserCacheManager: UserCacheManager {
    private var mockCache: [String: Any] = [:]
    
    private let cacheKey = "mockUserCache"
    private let pageKey = "mockPage"
    private let sinceKey = "mockSince"

    override func saveUsers(_ users: [User], page: Int, since: Int) {
        guard users.count <= 100 else { return } 

        mockCache[cacheKey] = users
        mockCache[pageKey] = page
        mockCache[sinceKey] = since
    }
    
    override func loadCachedUsers() -> ([User], Int, Int) {
        let users = mockCache[cacheKey] as? [User] ?? []
        let page = mockCache[pageKey] as? Int ?? 1
        let since = mockCache[sinceKey] as? Int ?? 0
        return (users, page, since)
    }
    
    override func clearCache() {
        mockCache.removeAll()
    }
}

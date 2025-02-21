//
//  UserCacheManagerTest.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//

import XCTest
@testable import TymeX_Assignment

final class UserCacheManagerTests: XCTestCase {
    var cacheManager: UserCacheManager!
    var mockCacheService: MockCacheService!

    override func setUp() {
        super.setUp()
        mockCacheService = MockCacheService()
        cacheManager = UserCacheManager(cacheService: mockCacheService)
    }

    override func tearDown() {
        cacheManager.clearCache()
        super.tearDown()
    }

    func generateUsers(count: Int) -> [User] {
        return (1...count).map { User(login: "User\($0)", html_url: "profile\($0)", avatar_url: "url\($0)", id: $0) }
    }

    func testSaveAndLoadUsers() {
        let users = generateUsers(count: 50)
        let page = 2
        let since = 50

        cacheManager.saveUsers(users, page: page, since: since)

        let (cachedUsers, cachedPage, cachedSince) = cacheManager.loadCachedUsers()
        
        XCTAssertEqual(cachedUsers.count, 50, "User count should be 50")
        XCTAssertEqual(cachedUsers.first?.login, "User1", "First user should be User1")
        XCTAssertEqual(cachedUsers.last?.login, "User50", "Last user should be User50")
        XCTAssertEqual(cachedPage, page, "Page should be \(page)")
        XCTAssertEqual(cachedSince, since, "Since should be \(since)")
    }

    func testClearCache() {
        let users = generateUsers(count: 50)
        cacheManager.saveUsers(users, page: 2, since: 50)

        cacheManager.clearCache()
        
        let (cachedUsers, cachedPage, cachedSince) = cacheManager.loadCachedUsers()
        
        XCTAssertEqual(cachedUsers.count, 0, "Cache should be empty after clearing")
        XCTAssertEqual(cachedPage, 1, "Page should reset to 1")
        XCTAssertEqual(cachedSince, 0, "Since should reset to 0")
    }
}

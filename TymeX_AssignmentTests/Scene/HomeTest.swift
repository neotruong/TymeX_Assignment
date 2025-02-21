//
//  HomeTest.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//
import XCTest
import Combine
@testable import TymeX_Assignment

final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockCacheManager: MockUserCacheManager!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCacheManager = MockUserCacheManager()
        viewModel = HomeViewModel(userService: mockNetworkService, cacheManager: mockCacheManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockCacheManager = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Helper Method for Mocking Response
    private func setupMockResponse(users: [User], statusCode: Int = 200, error: Error? = nil) {
        if let error = error {
            mockNetworkService.shouldFail = true
            mockNetworkService.error = error
        } else {
            let jsonData = try! JSONEncoder().encode(users)
            mockNetworkService.setMockResponse(for: UserService.fetchUsers(page: 0, since: 50), data: jsonData, statusCode: statusCode)
        }
    }
    
    // MARK: - Tests
    func testLoadCachedUsers() {
        // Given
        let cachedUsers = TestHelper.generateUsers(count: 50)
        mockCacheManager.saveUsers(cachedUsers, page: 2, since: 50)

        let expectation = expectation(description: "Cache should load users into ViewModel")

        // When
        viewModel.apply(.onAppear)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            XCTAssertEqual(self.viewModel.listUsers.count, 50, "ViewModel should load cached users")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after loading cache")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchUsersSuccess() {
        // Given
        let newUsers = TestHelper.generateUsers(count: 50, startId: 51)
        let jsonData = try! JSONEncoder().encode(newUsers)
        mockNetworkService.setMockResponse(for: UserService.fetchUsers(page: 1, since: 0), data: jsonData, statusCode: 200)

        let expectation = expectation(description: "Fetch users successfully")

        // When
        viewModel.apply(.onAppear)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.listUsers.count, 50, "Users should be fetched and added")
            XCTAssertEqual(self.viewModel.listUsers.first?.id, 51, "First user's ID should match expected")
            XCTAssertEqual(self.viewModel.listUsers.last?.id, 100, "Last user's ID should match expected")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after fetching")
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchUsersFailure() {
        // Given
        let testError = NSError(domain: "TestError", code: 0, userInfo: nil)
        setupMockResponse(users: [], error: testError)

        let expectation = expectation(description: "Handle fetch failure")

        // When
        viewModel.apply(.onAppear)

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage, "Error message should be set")
                XCTAssertTrue(errorMessage!.contains("Error"), "Error message should be descriptive")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 2.0)
    }
}

//
//  DetailTest.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//
import XCTest
import Combine
@testable import TymeX_Assignment

final class DetailViewModelTests: XCTestCase {
    
    private var viewModel: DetailViewModel!
    private var mockUserService: MockNetworkService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockUserService = MockNetworkService()
        viewModel = DetailViewModel(userService: mockUserService)
    }

    override func tearDown() {
        viewModel = nil
        mockUserService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchUserDetail_Success() {
        let expectedUser = UserDetail(
            login: "testUser",
            avatarURL: "https://example.com/avatar.png",
            htmlURL: "https://github.com/testUser",
            location: "USA",
            followers: 10,
            following: 5
        )
        
        let jsonData = try! JSONEncoder().encode(expectedUser)
        mockUserService.setMockResponse(for: UserService.fetchUserDetail(username: expectedUser.login), data: jsonData, statusCode: 200)

        
        let expectation = expectation(description: "Fetch user details successfully")
        
        viewModel.apply(.onAppear(username: "testUser"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.userDetail?.login, expectedUser.login)
            XCTAssertEqual(self.viewModel.userDetail?.htmlURL, expectedUser.htmlURL)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchUserDetail_Failure() {
        mockUserService.shouldFail = true
        
        let expectation = expectation(description: "Fetch user details fails and sets errorMessage")
        
        viewModel.apply(.onAppear(username: "invalidUser"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.errorMessage!.contains("Error loading user details"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

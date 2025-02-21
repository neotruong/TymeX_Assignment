//
//  NetworkServiceTest.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//

import Foundation
import XCTest
import Combine
@testable import TymeX_Assignment

final class NetworkServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    private var mockService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
    }

    override func tearDown() {
        cancellables.removeAll()
        mockService = nil
        super.tearDown()
    }

    private func setupMockResponse<T: Encodable>(
        for endpoint: Service,
        object: T?,
        statusCode: Int = 200
    ) {
        let jsonData = object != nil ? try? JSONEncoder().encode(object) : nil
        mockService.setMockResponse(for: endpoint, data: jsonData, statusCode: statusCode)
    }

    // MARK: - Tests
    func testFetchDataSuccess() {
        // Given
        let expectedUser = User(login: "TestUser", html_url: "https://test.com", avatar_url: "https://test.com/avatar.png", id: 1)
        setupMockResponse(for: UserService.fetchUsers(page: 0, since: 10), object: expectedUser)

        let expectation = expectation(description: "Successful API Call")

        // When
        mockService.fetchData(as: User.self, endpoint: UserService.fetchUsers(page: 0, since: 10))
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { user in
                XCTAssertEqual(user.login, "TestUser")
                XCTAssertEqual(user.html_url, "https://test.com")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1)
    }

    func testFetchDataDecodingFailure() {
        // Given
        mockService.setMockResponse(for: UserService.fetchUsers(page: 0, since: 10), data: Data("Invalid JSON".utf8))

        let expectation = expectation(description: "Decoding Error")

        // When
        mockService.fetchData(as: User.self, endpoint: UserService.fetchUsers(page: 0, since: 10))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Error message should be set")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected decoding failure but got success")
            })
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1)
    }

}

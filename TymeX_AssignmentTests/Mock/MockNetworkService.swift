//
//  MockNetworkService.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//

import Foundation
import Combine
@testable import TymeX_Assignment

class MockNetworkService: NetworkProtocol {
    var mockResponses: [String: (Data?, Int)] = [:]
    var shouldFail: Bool = false
    var error: Error = NetworkError.badServerResponse

    func setMockResponse(for endpoint: Service, data: Data?, statusCode: Int = 200) {
        mockResponses[endpoint.getPath()] = (data, statusCode)
    }

    func fetchData<T: Decodable>(as type: T.Type, endpoint: Service) -> AnyPublisher<T, Error> {
        guard let (data, statusCode) = mockResponses[endpoint.getPath()] else {
            return Fail(error: NetworkError.badServerResponse).eraseToAnyPublisher()
        }

        let response = HTTPURLResponse(url: URL(string: endpoint.getPath())!,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)

        if shouldFail || statusCode != 200 {
            return Fail(error: error).eraseToAnyPublisher()
        }

        guard let data = data else {
            return Fail(error: NetworkError.badServerResponse).eraseToAnyPublisher()
        }

        return Just((data, response!))
            .setFailureType(to: Error.self)
            .tryMap { data, _ in data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

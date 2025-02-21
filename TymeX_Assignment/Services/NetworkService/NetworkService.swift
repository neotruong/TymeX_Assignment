//
//  NetworkService.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/18/25.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func fetchData <T: Decodable>(as type: T.Type, endpoint: Service) -> AnyPublisher<T, Error>
}

enum NetworkError: Error {
    case badServerResponse
    case decodingError
    case unknownError
    case customError(String)
    
    var localizedDescription: String {
        switch self {
        case .badServerResponse:
            return "The server response was invalid."
        case .decodingError:
            return "Failed to decode the response data."
        case .unknownError:
            return "An unknown error occurred."
        case .customError(let message):
            return message
        }
    }
}

final class NetworkService: NetworkProtocol {
    
    func fetchData<T: Decodable>(as type: T.Type, endpoint: Service) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint.getPath()) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badServerResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw NetworkError.badServerResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let decodingError = error as? DecodingError {
                    return .decodingError
                } else {
                    return .unknownError
                }
            }
            .eraseToAnyPublisher()
    }
    
}

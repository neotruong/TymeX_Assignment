//
//  NetworkConfig.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/18/25.
//

import Foundation

protocol Service {
    func getPath() -> String
}

// MARK: For mirror service
enum UserService: Service {
    case fetchUsers(page: Int, since: Int)
    case fetchUserDetail(username: String)
   
    func getPath() -> String {
        switch self {
        case .fetchUsers(let page, let since):
            return AppEndPoint.baseURL + "users?per_page=20&page=\(page)&since=\(since)"
        case .fetchUserDetail(let username):
            return AppEndPoint.baseURL + "users/\(username)"
        }
    }
}

class AppEndPoint {
    static var baseURL: String = "https://api.github.com/"
}

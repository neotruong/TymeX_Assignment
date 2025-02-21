//
//  TestHelper.swift
//  TymeX_AssignmentTests
//
//  Created by PRO on 2/21/25.
//

import Foundation
@testable import TymeX_Assignment

final class TestHelper {
    static func generateUsers(count: Int, startId: Int = 1) -> [User] {
        return (startId..<(startId + count)).map {
            User(login: "User\($0)", html_url: "profile\($0)", avatar_url: "url\($0)", id: $0)
        }
    }

}

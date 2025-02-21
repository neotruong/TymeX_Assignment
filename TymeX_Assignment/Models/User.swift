//
//  User.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import Foundation

struct User: Decodable, Equatable, Encodable {
    var login: String
    var html_url: String
    var avatar_url: String
    var id: Int
}

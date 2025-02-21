//
//  UserDetail.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import Foundation

struct UserDetail: Codable {
    let login: String
    let avatarURL: String
    let htmlURL: String
    let location: String?
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case location
        case followers
        case following
    }
    
    init(login: String, avatarURL: String, htmlURL: String, location: String?, followers: Int, following: Int) {
        self.login = login
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
        self.location = location
        self.followers = followers
        self.following = following
    }
}

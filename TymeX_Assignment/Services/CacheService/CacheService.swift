//
//  CacheService.swift
//  TymeX_Assignment
//
//  Created by PRO on 2/21/25.
//

import Foundation

protocol CacheServiceProtocol {
    func save<T: Codable>(_ object: T, forKey key: String)
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T?
    func remove(forKey key: String)
}

class CacheService: CacheServiceProtocol {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            userDefaults.set(encoded, forKey: key)
        }
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

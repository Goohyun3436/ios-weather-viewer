//
//  UserStorage.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/16/25.
//

import Foundation

final class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    @UserDefaultsJSON(key: .user, empty: UserData(test: true))
    var info {
        didSet {
            UserStaticStorage.info = info
        }
    }
    
}

enum UserStaticStorage {
    fileprivate(set) static var info = UserData(test: true)
}

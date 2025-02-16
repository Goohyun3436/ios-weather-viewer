//
//  UserDefaultsManager.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/16/25.
//

import Foundation

@propertyWrapper
final class UserDefault<T> {
    let key: UserDefaultsKey
    let empty: T
    
    var wrappedValue: T {
        get {
            return UserDefaultsManager.shared.getData(forKey: key) as? T ?? empty
        }
        set {
            UserDefaultsManager.shared.setData(newValue, forKey: key)
        }
    }
    
    init(key: UserDefaultsKey, empty: T) {
        self.key = key
        self.empty = empty
    }
    
}

@propertyWrapper
final class UserDefaultsJSON<T: Codable> {
    let key: UserDefaultsKey
    let empty: T
    
    var wrappedValue: T {
        get {
            return UserDefaultsManager.shared.loadJsonData(type: T.self, forKey: key) ?? empty
        }
        set {
            UserDefaultsManager.shared.saveJsonData(newValue, type: T.self, forKey: key)
        }
    }
    
    init(key: UserDefaultsKey, empty: T) {
        self.key = key
        self.empty = empty
    }
    
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func getData(forKey: UserDefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    func setData(_ data: Any?, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(data, forKey: forKey.rawValue)
    }
    
    func loadJsonData<T: Codable>(type: T.Type, forKey: UserDefaultsKey) -> T? {
        guard let savedData = UserDefaults.standard.object(forKey: forKey.rawValue) as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let savedObject = try? decoder.decode(T.self, from: savedData) else {
            return nil
        }
        
        return savedObject
    }
    
    func saveJsonData<T: Codable>(_ data: Any?, type: T.Type, forKey: UserDefaultsKey) {
        let encoder = JSONEncoder()
        let data = data as? T
        
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.setValue(encoded, forKey: forKey.rawValue)
        }
    }
    
    func removeObject(forKey: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
    
}

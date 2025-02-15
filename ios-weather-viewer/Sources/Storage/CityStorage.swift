//
//  CityStorage.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

final class CityStorage {
    
    static let shared = CityStorage()
    
    private init() {}
    
    static func load() {
        guard let cities = JSONManager.shared.load("CityInfo", CitiesInfo.self) else { return }
        
        CityStaticStorage.cities = cities.cities
    }
    
}

enum CityStaticStorage {
    fileprivate(set) static var cities = [CityInfo]()
}

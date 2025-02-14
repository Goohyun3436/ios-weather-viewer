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
        let fileName = "CityInfo"
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let data = jsonString.data(using: .utf8)
        
        guard let data, let cities = try? decoder.decode(CityInfo.self, from: data) else {
            return
        }
        
        CityStaticStorage.cities = cities
    }
    
}

enum CityStaticStorage {
    fileprivate(set) static var cities  = CityInfo(cities: [City]())
}

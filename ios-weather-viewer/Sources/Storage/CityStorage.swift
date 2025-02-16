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
    
    @UserDefaultsJSON(key: .city, empty: CityData(cityArray: [CityInfo](), citySet: Set<CityInfo>()))
    var info {
        didSet {
            CityStaticStorage.info = info
        }
    }
    
    func load() {
        let cityData = self.info
        
        if cityData.cityArray.isEmpty || cityData.citySet.isEmpty {
            self.jsonLoad()
        } else {
            self.userDefaultsLoad()
        }
    }
    
    private func jsonLoad() {
        print("jsonLoad")
        
        guard let cityInfo = JSONManager.shared.load("CityInfo", CitiesInfo.self) else { return }
        
        var cityData = CityData(cityArray: [CityInfo](), citySet: Set<CityInfo>())
        
        cityData.cityArray = cityInfo.cities
        
        cityInfo.cities.forEach {
            cityData.citySet.insert($0)
        }
        
        self.info = cityData
        
        dump(CityStaticStorage.info)
    }
    
    private func userDefaultsLoad() {
        print("userDefaultsLoad")
        CityStaticStorage.info = info
        
        dump(NSHomeDirectory())
    }
    
}

enum CityStaticStorage {
    fileprivate(set) static var info = CityData(cityArray: [CityInfo](), citySet: Set<CityInfo>())
}

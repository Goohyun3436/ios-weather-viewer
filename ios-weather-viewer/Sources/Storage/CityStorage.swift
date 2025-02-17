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
    
    @UserDefaultsJSON(key: .city, empty: CityData())
    var info {
        didSet {
            CityStaticStorage.info = info
        }
    }
    
    func load() {
        let cityData = self.info
        
        if cityData.cityArray.isEmpty || cityData.citySet.isEmpty {
            self.info = self.jsonLoad()
        } else {
            CityStaticStorage.info = self.info
        }
    }
    
    private func jsonLoad() -> CityData {
        guard let cityInfo = JSONManager.shared.load("CityInfo", CitiesInfo.self) else {
            return CityStaticStorage.info
        }
        
        var cityData = CityData(cityArray: [CityInfo](), citySet: Set<CityInfo>())
        
        cityData.cityArray = cityInfo.cities
        
        cityInfo.cities.forEach {
            cityData.citySet.insert($0)
        }
        
        return cityData
    }
    
    func userCity() -> CityInfo? {
        return self.city(of: UserStorage.shared.info.cityId)
    }
    
    func city(of cityId: CityId) -> CityInfo? {
        return CityStaticStorage.info.citySet.first(where: { $0.id == cityId })
    }
    
}

enum CityStaticStorage {
    fileprivate(set) static var info = CityData()
}

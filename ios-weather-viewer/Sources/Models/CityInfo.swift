//
//  CityInfo.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

struct CitiesInfo: Decodable {
    let cities: [CityInfo]
}

struct CityInfo: Codable, Hashable {
    let id: CityId
    let city: String
    let koCityName: String
    let country: String
    let koCountryName: String
    let locationName: String
    
    enum CodingKeys: String, CodingKey {
        case id, city, koCityName, country, koCountryName
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        city = try container.decode(String.self, forKey: .city)
        koCityName = try container.decode(String.self, forKey: .koCityName)
        country = try container.decode(String.self, forKey: .country)
        koCountryName = try container.decode(String.self, forKey: .koCountryName)
        locationName = "\(koCountryName), \(koCityName)"
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id.hashValue)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct CityData: Codable {
    var cityArray = [CityInfo]()
    var citySet = Set<CityInfo>()
}

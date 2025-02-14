//
//  CityInfo.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

struct CityInfo: Decodable {
    let cities: [City]
}

struct City: Decodable {
    let id: Int
    let city: String
    let koCityName: String
    let country: String
    let koCountryName: String
}

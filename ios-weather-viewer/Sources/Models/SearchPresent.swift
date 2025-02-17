//
//  SearchPresent.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/16/25.
//

import Foundation

struct SearchPresent {
    var cities: [CityWeatherInfo]
}

struct CityWeatherInfo {
    let id: Int
    let koCityName: String
    let koCountryName: String
    let iconUrl: String
    let tempMinMax: String
    let temp: String
}

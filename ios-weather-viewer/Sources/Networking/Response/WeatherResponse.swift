//
//  WeatherResponse.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

struct WeatherGroupResponse: Decodable {
    let list: [WeatherResponse]
}

struct WeatherResponse: Decodable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let dt: Int
    let sys: SysInfo
}

struct WeatherInfo: Decodable {
    let main: String
    let description: String
    let icon: String
    let iconUrl: String
    
    enum CodingKeys: String, CodingKey {
        case main, description, icon
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
        iconUrl = WeatherImageRequest.small(icon).endpoint
    }
}

struct MainInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
}

struct WindInfo: Decodable {
    let speed: Double
}

struct SysInfo: Decodable {
    let sunrise: Int
    let sunset: Int
}

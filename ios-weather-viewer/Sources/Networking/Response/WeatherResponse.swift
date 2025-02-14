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

struct ForecastResponse: Decodable {
    let list: [ForecastWeatherInfo]
}

struct ForecastWeatherInfo: Decodable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let dt: Int
    let pop: Double
    let snow: Volume?
    let rain: Volume?
    
    enum CodingKeys: String, CodingKey {
        case weather, main, wind, dt, pop, snow, rain
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decode([WeatherInfo].self, forKey: .weather)
        main = try container.decode(MainInfo.self, forKey: .main)
        wind = try container.decode(WindInfo.self, forKey: .wind)
        dt = try container.decode(Int.self, forKey: .dt)
        pop = try container.decode(Double.self, forKey: .pop)
        snow = try container.decodeIfPresent(Volume.self, forKey: .snow)
        rain = try container.decodeIfPresent(Volume.self, forKey: .rain)
    }
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

struct Volume: Decodable {
    let h3: Double
    
    enum CodingKeys: String, CodingKey {
        case h3 = "3h"
    }
}

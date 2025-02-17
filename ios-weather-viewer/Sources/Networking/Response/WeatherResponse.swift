//
//  WeatherResponse.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

struct WeatherGroupResponse: Decodable {
    var list: [WeatherResponse]
}

struct WeatherResponse: Decodable, Hashable {
    let id: CityId
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let dt: Int
    let sys: SysInfo
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case id, weather, main, wind, dt, sys
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(CityId.self, forKey: .id)
        weather = try container.decode([WeatherInfo].self, forKey: .weather)
        main = try container.decode(MainInfo.self, forKey: .main)
        wind = try container.decode(WindInfo.self, forKey: .wind)
        dt = try container.decode(Int.self, forKey: .dt)
        sys = try container.decode(SysInfo.self, forKey: .sys)
        datetime = DateManager.shared.utcToKst(dt, for: .datetime)
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id.hashValue)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

struct ForecastResponse: Decodable {
    let list: [ForecastInfo]
}

struct ForecastInfo: Decodable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let dt: Int
    let pop: Double
    let snow: Volume?
    let rain: Volume?
    let datetime: String
    
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
        datetime = DateManager.shared.utcToKst(dt, for: .datetime)
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
    let sunriseText: String
    let sunsetText: String
    
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        sunriseText = DateManager.shared.utcToKst(sunrise, for: .time)
        sunsetText = DateManager.shared.utcToKst(sunset, for: .time)
    }
}

struct Volume: Decodable {
    let h3: Double
    
    enum CodingKeys: String, CodingKey {
        case h3 = "3h"
    }
}

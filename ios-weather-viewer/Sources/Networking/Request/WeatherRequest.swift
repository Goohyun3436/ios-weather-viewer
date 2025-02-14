//
//  WeatherRequest.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

enum WeatherRequest {
    typealias CityId = Int
    typealias Parameters = [String: String]
    
    case group(_ ids: [CityId], _ units: MeasurementUnit = .metric, _ language: Language = .kr)
    case weather(_ id: CityId, _ units: MeasurementUnit = .metric, _ language: Language = .kr)
    case forecast(_ id: CityId, _ units: MeasurementUnit = .metric, _ language: Language = .kr)
    
    var endpoint: String {
        return APIUrl.openWeather + self.path
    }
    
    private var path: String {
        switch self {
        case .group:
            return "/group"
        case .weather:
            return "/weather"
        case .forecast:
            return "/forecast"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .group(let ids, let units, let language):
            let id = ids.map { String($0) }.joined(separator: ",")
            return [
                "id": id,
                "appid": APIKey.openWeather,
                "units": units.rawValue,
                "lang": language.rawValue
            ]
        case .weather(let id, let units, let language):
            return [
                "id": "\(id)",
                "appid": APIKey.openWeather,
                "units": units.rawValue,
                "lang": language.rawValue
            ]
        case .forecast(let id, let units, let language):
            return [
                "id": "\(id)",
                "appid": APIKey.openWeather,
                "units": units.rawValue,
                "lang": language.rawValue
            ]
        }
    }
}

enum WeatherImageRequest {
    case small(_ icon: String)
    case twice(_ icon: String)
    
    var endpoint: String {
        return APIUrl.openWeatherImage + self.path
    }
    
    private var path: String {
        switch self {
        case .small(let icon):
            return "/img/wn/\(icon).png"
        case .twice(let icon):
            return "/img/wn/\(icon)@2x.png"
        }
    }
}

enum MeasurementUnit: String {
    case standard
    case metric
    case imperial
}

enum Language: String {
    case en
    case kr
}

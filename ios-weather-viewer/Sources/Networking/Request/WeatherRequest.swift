//
//  WeatherRequest.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

enum WeatherRequest {
    typealias Query = String
    typealias Parameters = [String: String]
    
    case current(_ query: Query, _ units: MeasurementUnit = .metric, _ language: Language = .kr)
    case image(_ icon: String, _ scale: ImageScale = .small)
    
    var endpoint: String {
        return APIUrl.openWeather + self.path
    }
    
    private var path: String {
        switch self {
        case .current:
            return "/data/2.5/weather"
        case .image(let icon, let scale):
            return "/img/wn/\(icon)\(scale).png"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .current(let query, let units, let language):
            return [
                "q": query,
                "appid": APIKey.openWeather,
                "units": units.rawValue,
                "lang": language.rawValue
            ]
        case .image(_, _):
            return [:]
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

enum ImageScale: String {
    case small = ""
    case twice = "@2x"
}

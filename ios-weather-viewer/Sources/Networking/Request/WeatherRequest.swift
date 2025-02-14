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
    case current(_ id: CityId, _ units: MeasurementUnit = .metric, _ language: Language = .kr)
    case image(_ icon: String, _ scale: ImageScale = .small)
    
    var endpoint: String {
        return APIUrl.openWeather + self.path
    }
    
    private var path: String {
        switch self {
        case .group:
            return "/data/2.5/group"
        case .current:
            return "/data/2.5/weather"
        case .image(let icon, let scale):
            return "/img/wn/\(icon)\(scale).png"
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
        case .current(let id, let units, let language):
            return [
                "id": "\(id)",
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

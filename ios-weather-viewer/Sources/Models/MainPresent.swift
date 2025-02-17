//
//  MainPresent.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import Foundation

struct MainPresent {
    let locationName: String
    let datetime: String
    let weatherChat: IconNLabelChat
    let tempChat: LabelNSubLabelChat
    let feelsLikeTempChat: LabelChat
    let sunriseNSunsetChat: LabelChat
    let humidityNWindspeedChat: LabelChat
    let photoChat: ImageNLabelChat
}

struct IconNLabelChat {
    let image: String
    let imagePlaceholder: String
    let text: String
    let targetStrings: [String]
}

struct LabelNSubLabelChat {
    let text: String
    let subText: String
    let targetStrings: [String]
}

struct LabelChat {
    let text: String
    let targetStrings: [String]
}

struct ImageNLabelChat {
    let text: String
    let image: String
    let imagePlaceholder: String
}

enum Chat: CaseIterable {
    case weather
    case temp
    case fellsLikeTemp
    case sunriseNSunset
    case humidityNWindspeed
    case photo
}


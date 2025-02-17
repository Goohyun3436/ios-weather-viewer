//
//  PhotoResponse.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

struct PhotoResponse: Decodable {
    let results: [PhotoInfo]
}

struct PhotoInfo: Decodable {
    let urls: UrlsInfo
    let width: Int
    let height: Int
}

struct UrlsInfo: Decodable {
    let small: String
}

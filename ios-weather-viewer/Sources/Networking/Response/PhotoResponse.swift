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

//MARK: - Error
enum PhotoError: APIError {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case server
    case unowned
    
    init(_ statusCode: Int?) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500, 503:
            self = .server
        default:
            self = .unowned
        }
    }
    
    var statusCode: String {
        switch self {
        case .badRequest:
            return "400"
        case .unauthorized:
            return "401"
        case .forbidden:
            return "403"
        case .notFound:
            return "404"
        case .server:
            return "500, 503"
        case .unowned:
            return "0"
        }
    }
    
    var message: String {
        switch self {
        case .badRequest:
            return "리소스 가져오기에 실패했습니다."
        case .unauthorized:
            return "사용자를 찾을 수 없습니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "리소스 가져오기에 실패했습니다."
        case .server:
            return "Unsplash 서버에 문제가 생겼습니다."
        case .unowned:
            return "Unsplash 뷰어에 문제가 생겼습니다."
        }
    }
}

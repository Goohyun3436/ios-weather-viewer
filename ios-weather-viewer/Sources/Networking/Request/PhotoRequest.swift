//
//  PhotoRequest.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

enum PhotoRequest: APIRequest {
    case search(_ query: Query,
                      _ page: Int = 1,
                      _ perPage: Int = 1,
                      _ orderBy: OrderBy = .relevant)
    
    var endpoint: String {
        return APIUrl.unsplash + self.path
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/photos"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let query, let page, let perPage, let orderBy):
            return [
                "query": query,
                "page": "\(page)",
                "per_page": "\(perPage)",
                "order_by": orderBy.rawValue
            ]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: HTTPHeaders? {
        return ["Authorization": APIKey.unsplash]
    }
}

enum OrderBy: String {
    case relevant
    case latest
}

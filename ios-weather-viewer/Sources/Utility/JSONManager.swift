//
//  JSONManager.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import Foundation

final class JSONManager {
    
    static let shared = JSONManager()
    
    private init() {}
    
    func load<ResponseT: Decodable>(
        _ fileName: String,
        _ responseT: ResponseT.Type
    ) -> ResponseT? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let data = jsonString.data(using: .utf8)
        
        guard let data, let decode = try? decoder.decode(responseT, from: data) else {
            return nil
        }
        
        return decode
    }
    
}

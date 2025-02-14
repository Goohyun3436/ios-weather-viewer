//
//  NetworkManager.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func openWeather<ResponseType: Decodable>(
        _ request: WeatherRequest,
        _ responseT: ResponseType.Type,
        completionHandler: @escaping (ResponseType) -> Void,
        failureHandler: @escaping () -> Void
    ) {
        guard var urlComponents = URLComponents(string: request.endpoint)  else { return }
        
        urlComponents.queryItems = request.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponents.url else { return }
        
        let urlRequest = URLRequest(url: url, timeoutInterval: 5)
        
        print(urlComponents)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, err in
            if let err {
                print("===err===", err)
                failureHandler()
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            guard (200...299).contains(response.statusCode) else {
                print("===statusCode===", response.statusCode)
                print(response)
                failureHandler()
                return
            }
            
            guard let contentLength = response.value(forHTTPHeaderField: "Content-Length") else { return }
            
            guard let data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let value = try decoder.decode(responseT, from: data)
                completionHandler(value)
            } catch {
                print(error)
                failureHandler()
            }
            
        }.resume()
    }
    
}

//
//  NetworkManager.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/14/25.
//

import Foundation

protocol APIRequest {
    var endpoint: String { get }
    var path: String { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var header: HTTPHeaders? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<ResponseType: Decodable>(
        _ request: APIRequest,
        _ responseT: ResponseType.Type,
        completionHandler: @escaping (ResponseType) -> Void,
        failureHandler: @escaping () -> Void
    ) {
        guard var urlComponents = URLComponents(string: request.endpoint)  else { return }
        
        urlComponents.queryItems = request.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 5)
        urlRequest.httpMethod = request.method.rawValue
        
        if let header = request.header {
            header.forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
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
                
                DispatchQueue.main.async {
                    completionHandler(value)
                }
            } catch {
                print(error)
                
                DispatchQueue.main.async {
                    failureHandler()
                }
            }
            
        }.resume()
    }
    
}

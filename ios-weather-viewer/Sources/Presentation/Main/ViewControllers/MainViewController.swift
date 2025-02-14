//
//  MainViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

class MainViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        openWeatherCurrentAPI()
    }
    
    private func openWeatherCurrentAPI() {
        
        let query: String? = "london"
        
        guard let query else { return }
        
        NetworkManager.shared.weather(.current(query), WeatherResponse.self) { data in
            dump(data)
        } failureHandler: {
            print("실패!!!!")
        }
    }
    
}

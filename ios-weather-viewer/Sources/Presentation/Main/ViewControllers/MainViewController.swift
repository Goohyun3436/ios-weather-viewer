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
        
        openWeatherGroupAPI()
    }
    
    private func openWeatherGroupAPI() {
        
        let ids: [Int]? = [6094817, 5128581, 2643743]
        
        guard let ids else { return }
        
        NetworkManager.shared.weather(.group(ids), WeatherGroupResponse.self) { data in
            dump(data)
        } failureHandler: {
            print("실패!!!!")
        }
    }
    
    private func openWeatherCurrentAPI() {
        
        let id: Int? = 6094817
        
        guard let id else { return }
        
        NetworkManager.shared.weather(.current(id), WeatherResponse.self) { data in
            dump(data)
        } failureHandler: {
            print("실패!!!!")
        }
    }
    
    
    
}

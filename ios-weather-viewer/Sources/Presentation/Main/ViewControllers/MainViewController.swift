//
//  MainViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

class MainViewController: BaseViewController {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let id: Int? = 524901
        
        guard let id else { return }
        
        NetworkManager.shared.openWeather(.forecast(id), ForecastResponse.self) { data in
            dump(data)
        } failureHandler: {
            print("실패!!!!")
        }

        
    }
    
}

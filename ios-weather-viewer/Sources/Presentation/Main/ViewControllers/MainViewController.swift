//
//  MainViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit
import Kingfisher
import SnapKit

class MainViewController: BaseViewController {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        imageView.clipsToBounds = true
        
        openWeatherImageAPI()
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
    
    private func openWeatherImageAPI() {
        let iconUrl1: String? = "https://openweathermap.org/img/wn/01n.png"
        let iconUrl2: String? = "https://openweathermap.org/img/wn/01n@2x.png"
        
        guard let iconUrl1, let iconUrl2 else { return }
        
        let url = URL(string: iconUrl1)
        imageView.kf.setImage(with: url)
    }
    
}

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
    
    private let imageView1 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(imageView1)
        imageView1.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.equalTo(400)
            make.height.equalTo(200)
        }
        
        let query: Query? = "Clouds"
        
        guard let query else { return }
        
        NetworkManager.shared.request(PhotoRequest.search(query), PhotoResponse.self) { [weak self] data in
            let small = URL(string: data.results[0].urls.small)
            
            DispatchQueue.main.async {
                self?.imageView1.kf.setImage(with: small)
            }
        } failureHandler: {
            print("실패!!!")
        }

        
        
    }
    
}

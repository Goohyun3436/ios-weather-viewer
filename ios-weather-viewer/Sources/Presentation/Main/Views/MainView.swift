//
//  MainView.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    //MARK: - UI Property
    let locationNameLabel = UILabel()
    let datetimeLabel = UILabel()
    let tableView = UITableView()
    let forecastButton = UIButton()
    
    //MARK: - Setup Method
    override func setupUI() {
        [locationNameLabel, datetimeLabel, tableView, forecastButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
        }
        
        datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datetimeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(forecastButton.snp.top)
        }
        
        forecastButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    override func setupAttributes() {
        locationNameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        datetimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        tableView.bounces = false
        tableView.separatorStyle = .none
        forecastButton.tintColor = UIColor.black
        forecastButton.setTitleColor(UIColor.black, for: .normal)
        forecastButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
}

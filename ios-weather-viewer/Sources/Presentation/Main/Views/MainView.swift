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
    
    //MARK: - Setup Method
    override func setupUI() {
        [locationNameLabel, datetimeLabel, tableView].forEach {
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
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        locationNameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        datetimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        tableView.bounces = false
        tableView.separatorStyle = .none
    }
    
}

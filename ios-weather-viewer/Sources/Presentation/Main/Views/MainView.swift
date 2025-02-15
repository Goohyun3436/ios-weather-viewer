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
    let titleLabel = UILabel()
    let datetimeLabel = UILabel()
    let tableView = UITableView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [titleLabel, datetimeLabel, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
        }
        
        datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datetimeLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        datetimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.bounces = false
        
        tableView.backgroundColor = .red
    }
    
}

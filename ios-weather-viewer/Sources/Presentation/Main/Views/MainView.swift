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
    
    //MARK: - Setup Method
    override func setupUI() {
        [titleLabel, datetimeLabel].forEach {
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
    }
    
    override func setupAttributes() {
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        datetimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
}

//
//  CityTableViewCell.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/16/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CityTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let wrapView = UIView()
    private let cityNameLabel = UILabel()
    private let countryNameLabel = UILabel()
    private let tempMinMaxLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    
    //MARK: - Property
    static let id = "CityTableViewCell"
    
    //MARK: - Method
    func setData(_ data: CityWeatherInfo) {
        cityNameLabel.text = data.koCityName
        countryNameLabel.text = data.koCountryName
        tempMinMaxLabel.text = data.tempMinMax
        iconImageView.kf.setImage(
            with: URL(string: data.iconUrl),
            placeholder: UIImage(systemName: data.iconPlaceholder)
        )
        tempLabel.text = data.temp
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(wrapView)
        
        [cityNameLabel, countryNameLabel, tempMinMaxLabel, iconImageView, tempLabel].forEach {
            wrapView.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        let inset: CGFloat = 10
        
        wrapView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(wrapView).offset(inset)
            // 우측 최소 값 설정 필요
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(wrapView).offset(inset)
        }
        
        tempMinMaxLabel.snp.makeConstraints { make in
            make.leading.equalTo(wrapView).offset(inset)
            make.bottom.equalTo(wrapView).inset(inset)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(wrapView).offset(2)
            make.trailing.equalTo(wrapView).inset(6)
            make.size.equalTo(44)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.trailing.bottom.equalTo(wrapView).inset(inset)
        }
    }
    
    override func setupAttributes() {
        wrapView.layer.cornerRadius = 8
        wrapView.layer.borderWidth = 1
        wrapView.layer.borderColor = UIColor.black.cgColor
        cityNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        countryNameLabel.font = UIFont.systemFont(ofSize: 12)
        tempMinMaxLabel.font = UIFont.systemFont(ofSize: 12)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}

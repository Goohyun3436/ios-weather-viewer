//
//  ImageNLabelTableViewCell.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit
import Kingfisher
import SnapKit

final class ImageNLabelTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let bubble = BubbleView(axis: .horizontal)
    private let leftImageView = UIImageView()
    private let label = AttributedLabel()
    
    //MARK: - Property
    static let id = "ImageNLabelTableViewCell"
    
    //MARK: - Method
    func setData(image: String?, text: String?, targetStrings: [String]) {
        if let image, let url = URL(string: image) {
            leftImageView.kf.setImage(with: url)
        }
        
        label.text = text
        label.asFont(targetStrings, font: UIFont.systemFont(ofSize: 12, weight: .bold))
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(bubble)
        
        [leftImageView, label].forEach {
            bubble.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        bubble.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView).inset(8)
            make.trailing.lessThanOrEqualTo(contentView).inset(-8)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    override func setupAttributes() {
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
}

//
//  IconNLabelTableViewCell.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit
import Kingfisher
import SnapKit

final class IconNLabelTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let bubble = BubbleView(axis: .horizontal)
    private let leftImageView = UIImageView()
    private let label = AttributedLabel()
    
    //MARK: - Property
    static let id = "ImageNLabelTableViewCell"
    
    //MARK: - Method
    func setData(_ chat: IconNLabelChat) {
        leftImageView.kf.setImage(with: URL(string: chat.image))
        label.text = chat.text
        label.asFont(chat.targetStrings, font: UIFont.systemFont(ofSize: 12, weight: .bold))
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

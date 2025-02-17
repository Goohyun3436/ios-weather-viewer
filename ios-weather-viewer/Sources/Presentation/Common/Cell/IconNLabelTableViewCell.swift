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
    private let iconWrapView = UIView()
    private let iconImageView = UIImageView()
    private let label = AttributedLabel()
    
    //MARK: - Property
    static let id = "IconNLabelTableViewCell"
    
    //MARK: - Method
    func setData(_ chat: IconNLabelChat) {
        iconImageView.kf.setImage(
            with: URL(string: chat.image),
            placeholder: UIImage(systemName: chat.imagePlaceholder)
        )
        label.text = chat.text
        label.asFont(chat.targetStrings, font: UIFont.systemFont(ofSize: 14, weight: .bold))
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(bubble)
        iconWrapView.addSubview(iconImageView)
        
        [iconWrapView, label].forEach {
            bubble.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        bubble.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.lessThanOrEqualTo(contentView).offset(-16)
        }
        
        iconWrapView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(bubble).inset(10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(iconWrapView)
            make.horizontalEdges.equalTo(iconWrapView)
            make.bottom.lessThanOrEqualTo(iconWrapView).offset(-0)
            make.size.equalTo(17)
        }
    }
    
    override func setupAttributes() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
}

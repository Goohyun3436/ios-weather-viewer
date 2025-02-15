//
//  LabelTableViewCell.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit
import SnapKit

final class LabelTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let bubble = BubbleView(axis: .horizontal)
    private let label = AttributedLabel()
    
    //MARK: - Property
    static let id = "LabelTableViewCell"
    
    //MARK: - Method
    func setData(_ chat: LabelChat) {
        label.text = chat.text
        label.asFont(chat.targetStrings, font: UIFont.systemFont(ofSize: 14, weight: .bold))
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(bubble)
        bubble.addArrangedSubview(label)
    }
    
    override func setupConstraints() {
        bubble.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.lessThanOrEqualTo(contentView).offset(-16)
        }
    }
    
    override func setupAttributes() {
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
}

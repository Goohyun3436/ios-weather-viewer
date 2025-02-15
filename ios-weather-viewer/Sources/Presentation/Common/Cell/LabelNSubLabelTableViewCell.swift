//
//  LabelNSubLabelTableViewCell.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit
import SnapKit

final class LabelNSubLabelTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Property
    private let bubble = BubbleView(axis: .horizontal)
    private let label = AttributedLabel()
    private let subLabel = UILabel()
    
    //MARK: - Property
    static let id = "LabelNSubLabelTableViewCell"
    
    //MARK: - Method
    func setData(_ chat: LabelNSubLabelChat) {
        label.text = chat.text
        label.asFont(chat.targetStrings, font: UIFont.systemFont(ofSize: 14, weight: .bold))
        subLabel.text = chat.subText
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(bubble)
        
        [label, subLabel].forEach {
            bubble.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        bubble.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView).inset(8)
            make.trailing.lessThanOrEqualTo(contentView).inset(-8)
        }
    }
    
    override func setupAttributes() {
        label.font = UIFont.systemFont(ofSize: 14)
        subLabel.font = UIFont.systemFont(ofSize: 12)
        subLabel.textColor = UIColor.gray
    }
    
}

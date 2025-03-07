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
    private let bubble = BubbleView(axis: .vertical)
    private let label = UILabel()
    private let photoImageView = UIImageView()
    
    //MARK: - Property
    static let id = "ImageNLabelTableViewCell"
    
    //MARK: - Method
    func setData(_ chat: ImageNLabelChat) {
        label.text = chat.text
        photoImageView.kf.setImage(
            with: URL(string: chat.image),
            placeholder: UIImage(named: chat.imagePlaceholder)
        )
    }
    
    //MARK: - Setup Method
    override func setupUI() {
        contentView.addSubview(bubble)
        
        [label, photoImageView].forEach {
            bubble.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        bubble.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 56)
            make.height.equalTo(200)
        }
    }
    
    override func setupAttributes() {
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.contentMode = .scaleAspectFill
    }
    
}

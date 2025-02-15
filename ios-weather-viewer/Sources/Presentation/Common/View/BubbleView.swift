//
//  BubbleView.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit

final class BubbleView: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        
        self.axis = axis
        
        switch axis {
        case .horizontal:
            self.alignment = .top
        case .vertical:
            self.alignment = .leading
        @unknown default:
            self.alignment = .top
        }
        
        self.spacing = 8
        self.layer.cornerRadius = 8
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self.backgroundColor = UIColor.white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

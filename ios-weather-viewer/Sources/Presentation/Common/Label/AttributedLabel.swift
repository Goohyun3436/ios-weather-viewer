//
//  AttributedLabel.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import UIKit

final class AttributedLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func asFont(_ targetStrings: [String], font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        targetStrings.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.font: font], range: range)
        }
        
        attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

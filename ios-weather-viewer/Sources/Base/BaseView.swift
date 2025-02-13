//
//  BaseView.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupAttributes()
    }
    
    func setupUI() {}
    func setupConstraints() {}
    func setupAttributes() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

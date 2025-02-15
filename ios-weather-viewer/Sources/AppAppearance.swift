//
//  AppAppearance.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        let appearanceN = UINavigationBarAppearance()
        appearanceN.configureWithTransparentBackground()
        appearanceN.backgroundColor = UIColor.white
        appearanceN.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        appearanceN.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().standardAppearance = appearanceN
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceN
        
        BaseView.appearance().backgroundColor = UIColor.white
        BaseTableViewCell.appearance().selectionStyle = .none
        
        UITableView.appearance().bounces = false
        UITableView.appearance().separatorStyle = .none
    }
    
}

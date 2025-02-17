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
        
        UIBarButtonItem.appearance().tintColor = UIColor.black
        
        BaseView.appearance().backgroundColor = UIColor.white
        BaseTableViewCell.appearance().selectionStyle = .none
        BaseTableViewCell.appearance().backgroundColor = UIColor.white
        
        UILabel.appearance().textColor = UIColor.black
        
        UISearchBar.appearance().barTintColor = UIColor.white
        UISearchBar.appearance().keyboardAppearance = UIKeyboardAppearance.light
        UISearchTextField.appearance().tintColor = UIColor.lightGray
        UISearchTextField.appearance().textColor = UIColor.black
        
        UITableView.appearance().bounces = false
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.white
    }
    
}

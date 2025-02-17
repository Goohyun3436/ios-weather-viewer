//
//  UIViewController+Extension.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/18/25.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(_ message: String, _ statusCode: String) {
        let alert = UIAlertController(title: "실패", message: "\(message) (\(statusCode))", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive)
        
        alert.addAction(ok)
        
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        
        present(alert, animated: true)
    }
}

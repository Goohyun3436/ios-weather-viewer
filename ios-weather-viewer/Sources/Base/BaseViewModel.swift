//
//  BaseViewModel.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform()
}

//
//  MainViewModel.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import Foundation

final class MainViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("")
        let refreshButtonImage = "arrow.clockwise"
        let searchButtonImage = "magnifyingglass"
    }
    
    //MARK: - Property
    private(set) var input: Input
    private(set) var output: Output
    
    //MARK: - Initializer Method
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    //MARK: - Transform
    func transform() {
        
    }
    
}

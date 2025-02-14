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
        let viewWillAppear: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("")
        let refreshButtonImage = "arrow.clockwise"
        let searchButtonImage = "magnifyingglass"
        let titleLabelText: Observable<String?> = Observable(nil)
        let datetimeLabelText: Observable<String?> = Observable(nil)
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
        input.viewWillAppear.lazyBind { [weak self] _ in
            self?.output.titleLabelText.value = "대한민국, 서울"
            self?.output.datetimeLabelText.value = "1월 29일(수) 오후 3시 12분"
        }
    }
    
}

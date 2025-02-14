//
//  MainViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit
import Kingfisher
import SnapKit

class MainViewController: BaseViewController {
    
    //MARK: - UI Property
    private let mainView = MainView()
    
    //MARK: - Property
    private let viewModel = MainViewModel()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupActions() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: viewModel.output.searchButtonImage),
                style: .plain,
                target: self,
                action: #selector(searchButtonTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: viewModel.output.refreshButtonImage),
                style: .plain,
                target: self,
                action: #selector(refreshButtonTapped)
            )
        ]
    }
    
    override func setupBinds() {
        viewModel.output.navigationTitle.bind { [weak self] title in
            self?.title = title
        }
    }
    
    //MARK: - Method
    @objc private func refreshButtonTapped() {}
    
    @objc private func searchButtonTapped() {}
    
}

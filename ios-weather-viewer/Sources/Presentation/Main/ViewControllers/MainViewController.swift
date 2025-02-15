//
//  MainViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

final class MainViewController: BaseViewController {
    
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
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ImageNLabelTableViewCell.self, forCellReuseIdentifier: ImageNLabelTableViewCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.value = ()
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
        
        viewModel.output.titleLabelText.lazyBind { [weak self] text in
            self?.mainView.titleLabel.text = text
        }
        
        viewModel.output.datetimeLabelText.lazyBind { [weak self] text in
            self?.mainView.datetimeLabel.text = text
        }
    }
    
    //MARK: - Method
    @objc private func refreshButtonTapped() {}
    
    @objc private func searchButtonTapped() {}
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageNLabelTableViewCell.id, for: indexPath) as! ImageNLabelTableViewCell
        cell.backgroundColor = .orange
        
        cell.setData(
            image: WeatherImageRequest.small("02n").endpoint,
            text: "오늘의 날씨는 맑음입니다.오늘의 날씨는 맑음입니다.오늘의 날씨는 맑음입니다.오늘의 날씨는 맑음입니다.오늘의 날씨는 맑음입니다.",
            targetStrings: ["맑음"]
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

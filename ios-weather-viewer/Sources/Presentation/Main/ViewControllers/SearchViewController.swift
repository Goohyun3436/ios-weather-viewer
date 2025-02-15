//
//  SearchViewController.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    //MARK: - UI Property
    private let mainView = SearchView()
    
    //MARK: - Property
    private let viewModel = SearchViewModel()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setupTableView()
        viewModel.input.viewDidLoad.value = ()
    }
    
    //MARK: - Setup Method
    override func setupActions() {
        
    }
    
    override func setupBinds() {
        viewModel.output.navigationTitle.bind { [weak self] title in
            self?.title = title
        }
        
        viewModel.output.backButtonTitle.bind { [weak self] title in
            self?.navigationItem.backButtonTitle = title
        }
        
        viewModel.output.searchBarPlaceholder.bind { [weak self] placeholder in
            self?.mainView.searchBar.placeholder = placeholder
        }
    }
    
    private func setupTableView() {
        mainView.tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.id)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as! CityTableViewCell
        
        if let cityWeather = viewModel.output.present.value?.cities[indexPath.row] {
            cell.setData(cityWeather)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

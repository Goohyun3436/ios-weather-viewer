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
        mainView.tableView.prefetchDataSource = self
        setupTableView()
        viewModel.input.viewDidLoad.value = ()
    }
    
    //MARK: - Setup Method
    override func setupActions() {
        let singleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(mainViewTapped)
        )
        singleTap.cancelsTouchesInView = false
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(singleTap)
    }
    
    @objc private func mainViewTapped() {
        viewModel.input.mainViewTapped.value = ()
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
        
        viewModel.output.present.lazyBind { [weak self] present in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.output.showsKeyboard.lazyBind { [weak self] show in
            self?.mainView.endEditing(show)
        }
    }
    
    private func setupTableView() {
        mainView.tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.id)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.present.value.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as! CityTableViewCell
        
        let cityWeather = viewModel.output.present.value.cities[indexPath.row]
        cell.setData(cityWeather)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.input.prefetchRowsAt.value = indexPaths
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

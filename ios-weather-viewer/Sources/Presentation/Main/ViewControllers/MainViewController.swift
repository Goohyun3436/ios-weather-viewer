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
        setupTableView()
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
        
        viewModel.output.forecastButtonImageTitle.bind { [weak self] button in
            self?.mainView.forecastButton.setImage(UIImage(systemName: button.image), for: .normal)
            self?.mainView.forecastButton.setTitle(button.title, for: .normal)
        }
        
        viewModel.output.present.lazyBind { [weak self] present in
            guard let present else {
                //대응 필요
                return
            }
            
            self?.mainView.locationNameLabel.text = present.locationName
            self?.mainView.datetimeLabel.text = present.datetime
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.output.pushVC.lazyBind { [weak self] _ in
            self?.navigationController?.pushViewController(SearchViewController(), animated: true)
        }
    }
    
    private func setupTableView() {
        mainView.tableView.register(IconNLabelTableViewCell.self, forCellReuseIdentifier: IconNLabelTableViewCell.id)
        mainView.tableView.register(LabelNSubLabelTableViewCell.self, forCellReuseIdentifier: LabelNSubLabelTableViewCell.id)
        mainView.tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.id)
        mainView.tableView.register(ImageNLabelTableViewCell.self, forCellReuseIdentifier: ImageNLabelTableViewCell.id)
    }
    
    //MARK: - Method
    @objc private func refreshButtonTapped() {
        viewModel.input.refreshButtonTapped.value = ()
    }
    
    @objc private func searchButtonTapped() {
        viewModel.input.searchButtonTapped.value = ()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.chatCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = viewModel.output.chatCases[indexPath.row]
        
        switch chat {
        case .weather:
            let cell = tableView.dequeueReusableCell(withIdentifier: IconNLabelTableViewCell.id, for: indexPath) as! IconNLabelTableViewCell
            
            if let chatInfo = viewModel.output.present.value?.weatherChat {
                cell.setData(chatInfo)
            }
            
            return cell
            
        case .temp:
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelNSubLabelTableViewCell.id, for: indexPath) as! LabelNSubLabelTableViewCell
            
            if let chatInfo = viewModel.output.present.value?.tempChat {
                cell.setData(chatInfo)
            }
            
            return cell
            
        case .fellsLikeTemp, .sunriseNSunset, .humidityNWindspeed:
            let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.id, for: indexPath) as! LabelTableViewCell
            
            if chat == .fellsLikeTemp,
               let chatInfo = viewModel.output.present.value?.feelsLikeTempChat {
                cell.setData(chatInfo)
            }
            
            if chat == .sunriseNSunset,
               let chatInfo = viewModel.output.present.value?.sunriseNSunsetChat {
                cell.setData(chatInfo)
            }
            
            if chat == .humidityNWindspeed,
               let chatInfo = viewModel.output.present.value?.humidityNWindspeedChat {
                cell.setData(chatInfo)
            }
            
            return cell
            
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageNLabelTableViewCell.id, for: indexPath) as! ImageNLabelTableViewCell
            
            if let chatInfo = viewModel.output.present.value?.photoChat {
                cell.setData(chatInfo)
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

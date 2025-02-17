//
//  SearchView.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    //MARK: - UI Property
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    //MARK: - Setup Method
    override func setupUI() {
        [searchBar, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        searchBar.searchBarStyle = .minimal
        tableView.keyboardDismissMode = .onDrag
    }
    
}

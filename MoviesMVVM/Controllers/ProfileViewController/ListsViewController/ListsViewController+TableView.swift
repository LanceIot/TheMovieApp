//
//  ListsViewController+TableView.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import Foundation
import UIKit

extension ListsViewController {
    
    func setupTableView() {
        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.backgroundColor = Constants.Colors.mainColor
        registerCells()
    }
    
    func registerCells() {
        listsTableView.register(ListsTableViewCell.self, forCellReuseIdentifier: ListsTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.listsTableView.reloadData()
        }
    }
}

//MARK: - TableView data source methods
extension ListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListsTableViewCell.identifier, for: indexPath) as? ListsTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = cellDataSource[indexPath.row]
        cell.configure(listViewModel: cellViewModel)
        return cell
    }
}

//MARK: - TableView delegate methods
extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return viewModel.getHeightForRow(indexPath: indexPath)
        let name = cellDataSource[indexPath.row].name
        let description = cellDataSource[indexPath.row].description
        
        print(name)
        print(description)
        
        let nameHeight = viewModel.heightForLabel(text: name, fontSize: 20)
        let descriptionHeight = viewModel.heightForLabel(text: description, fontSize: 14)
        
        return nameHeight + descriptionHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListViewController()
        vc.viewModel.typeOfList.value = .favorite
        vc.viewModel.listID = cellDataSource[indexPath.row].id
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

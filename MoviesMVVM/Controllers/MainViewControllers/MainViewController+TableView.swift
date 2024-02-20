//
//  MainViewController+TableView.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit

extension MainViewController {
    
    func setupTableView() {
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        
        self.mainTableView.backgroundColor = Constants.Colors.mainColor
        self.registerCells()
    }
    
    func createLoadFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func registerCells() {
        mainTableView.register(MainMovieCell.self, forCellReuseIdentifier: MainMovieCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}

//MARK: - UITableView data source methods
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieCell.identifier, for: indexPath) as? MainMovieCell else {
            return UITableViewCell()
        }
        let cellViewModel = cellDataSource[indexPath.row]
        cell.setupCell(viewModel: cellViewModel, tableView: tableView, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow()
    }
}

//MARK: - UITableView delegate methods
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = cellDataSource[indexPath.row].id
        self.openDetails(movieId: movieId)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if offsetY > height - scrollView.frame.size.height {
            mainTableView.tableFooterView = createLoadFooterView()
            viewModel.pageNumber+=1
            viewModel.getData { result in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self.reloadTableView()
                        self.mainTableView.tableFooterView = nil
                    }
                case .failure(let error):
                    print("Table FooterView error: \(error)")
                }
            }
        }
    }
}

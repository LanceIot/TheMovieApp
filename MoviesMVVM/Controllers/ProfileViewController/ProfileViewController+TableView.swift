//
//  ProfileViewController+TableView.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import Foundation
import UIKit

extension ProfileViewController {
    
    func setupTableView() {
        profileTableView.backgroundColor = Constants.Colors.mainColor
        profileTableView.dataSource = self
        profileTableView.delegate = self
        registerCells()
        
    }
    
    func registerCells() {
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.profileTableView.reloadData()
        }
    }
}

//MARK: - UITableView data source methods
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.configure(labelText: "Profile")
        case 1:
            cell.configure(labelText: "Favorites")
        case 2:
            cell.configure(labelText: "Watchlist")
        case 3:
            cell.configure(labelText: "Lists")
        default:
            print("Something wrong with ProfileTableViewCell")
        }
        return cell
    }
}

//MARK: - UITableView delegate methods
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.getHeightForRow()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Profile View Controller")
        case 1, 2:
            let vc = ListViewController()
            vc.viewModel.typeOfList.value = (indexPath.row == 1) ? .favorite : .watchlist
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            let vc = ListsViewController()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            print("Something wrong with ProfileTableViewCell")
        }
    }
}

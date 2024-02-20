//
//  SearchViewController+SearchController.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import Foundation
import UIKit

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text?.replacingOccurrences(of: " ", with: "+") {
            viewModel.query.value = searchQuery
            viewModel.removeData()
        } else {
            viewModel.removeData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.removeData()
        switch selectedScope {
        case 0:
            print("multi")
            viewModel.contentType = .multi
        case 1:
            print("movie")
            viewModel.contentType = .movie
        case 2:
            print("tv")
            viewModel.contentType = .tv
        default:
            viewModel.contentType = .multi
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = true

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = false
    }
}

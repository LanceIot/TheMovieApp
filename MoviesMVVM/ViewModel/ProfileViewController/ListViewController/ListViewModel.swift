//
//  ListViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import Foundation
import UIKit

class ListViewModel {
    
    var listID: Int?

    var selectedContentType: ListContentType = .movies
    var typeOfList: Obsorvable<ListType> = Obsorvable(nil)
    var cellDataSource: Obsorvable<[ListCollectionViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    
    
    func getData(completion: ((Result<Void, APICallerEror>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return 
        }
        
        isLoading.value = true
        let credentials = KeychainManager.shared.getCredentials()
        guard let accountID = credentials.accountDetails?.id,
        let sessionID = credentials.sessionID else {
            completion?(.failure(.cannotGetCredentials))
            return
        }
        
        
        switch typeOfList.value {
        case .favorite:
            APICaller.getAccountMovies(accountID: accountID, sessionID: sessionID, listType: "favorite", contentType: selectedContentType) { [weak self] result in
                self?.isLoading.value = false
                
                switch result {
                case .success(let data):
                    self?.dataSources = data
                    self?.mapCellData()
                case .failure(let error):
                    print("Cant fetch favorites: \(error)")
                    completion?(.failure(.cannotFetch))
                }
            }
        case .watchlist:
            APICaller.getAccountMovies(accountID: accountID, sessionID: sessionID, listType: "watchlist", contentType: selectedContentType) { [weak self] result in
                self?.isLoading.value = false
                
                switch result {
                case .success(let data):
                    self?.dataSources = data
                    self?.mapCellData()
                case .failure(let error):
                    print("Cant fetch watchlist: \(error)")
                    completion?(.failure(.cannotFetch))
                }
            }
        default:
            print("")
        }
        
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({ListCollectionViewCellViewModel(movie: $0)})
    }
    
    func getSizeForItem() -> CGSize {
        let width = UIScreen.main.bounds.size.width / 3.5
        let height = UIScreen.main.bounds.size.height / 5
        return CGSize(width: width, height: height)
    }
    
    func removeData() {
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
    }
}

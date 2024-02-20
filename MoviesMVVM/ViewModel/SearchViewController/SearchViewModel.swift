//
//  SearchViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import Foundation
import UIKit

class SearchViewModel {
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[SearchTableViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var query: Obsorvable<String> = Obsorvable("")
    var contentType: SearchContentType = .tv
    
    func getHeightForRow() -> CGFloat {
        return UIScreen.main.bounds.height * 0.1
    }
    
    func getData(completion: ((Result<Void, Error>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        APICaller.searchMovieRequest(contentType: contentType, query: query.value ?? "") { [weak self] result in
            self?.isLoading.value = false
            
            switch result {
            case .success(let data):
                print("Top trending counts: \(data.count)")
                self?.dataSources.append(contentsOf: data)
                self?.mapCellData()
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({SearchTableViewCellViewModel(movie: $0)})
    }
    
    func getMovieTitle(_ movie: TrendingMovieModel) -> String {
        return movie.title ?? movie.name ?? ""
    }
    
    func retriveMovie(by id: Int) -> TrendingMovieModel? {
        guard let movie = dataSources.first(where: {$0.id == id}) else {
            return nil
        }
        return movie
    }
    
    func removeData() {
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
    }
    
}

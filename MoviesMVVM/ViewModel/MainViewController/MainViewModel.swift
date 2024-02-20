//
//  MainViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit

class MainViewModel {
    
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[MainMovieCellViewModel]> = Obsorvable(nil)
    var dataSources: [TrendingMovieModel] = []
    var pageNumber = 1
    var contentType: MainContentType = .all
    var selectedCell: Int = 0
    var allContentTypes = ContentType.allCases
    
    //TableView
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int = 1) -> Int {
        return dataSources.count
    }
    
    func getHeightForRow() -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    func getData(completion: ((Result<Void, Error>) -> Void)? = nil) {
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        APICaller.getTrendingMovies(pageNumber: pageNumber, contentType: contentType) { [weak self] result in
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
        self.cellDataSource.value = self.dataSources.compactMap({MainMovieCellViewModel(movie: $0)})
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
    
    //CollectionView
    func isCollectionViewSelected(indexPath: Int) -> Bool {
        if indexPath == selectedCell {
            return true
        }
        return false
    }
    
    func removeDataAfterSelectedCell(contentType: MainContentType) {
        self.contentType = contentType
        cellDataSource.value?.removeAll()
        dataSources.removeAll()
        pageNumber = 1
    }
}

//
//  ListTableViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import Foundation

class ListCollectionViewCellViewModel {
    
    var id: Int
    var title: String
    var date: String
    var imageUrl: String?
    
    init(movie: TrendingMovieModel) {
        self.id = movie.id
        self.title = movie.title ?? movie.name ?? ""
        self.date = movie.releaseDate ?? movie.firstAirDate ?? ""
        self.imageUrl = movie.posterPath
    }
}

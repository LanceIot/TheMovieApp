//
//  DetailsMovieViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit

class DetailsMovieViewModel {
    
    var movie: TrendingMovieModel
    
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var isPresenting: Obsorvable<Bool> = Obsorvable(false)
    
    var movieID: Int
    var movieImageUrl: URL?
    var movieTitle: String
    var movieDescription: String
    var movieImage: UIImage?
    
    init(movie: TrendingMovieModel) {
        self.movie = movie
        
        self.movieID = movie.id
        self.movieTitle = movie.title ?? movie.name ?? ""
        self.movieDescription = movie.overview ?? ""
        self.movieImageUrl = makeImageURL(movie.backdropPath ?? "")

    }
    
    private func makeImageURL( _ imageCode: String) -> URL? {
        URL(string: "\(NetworkConstant.shared.imageServerAddress)\(imageCode)")
    }
    
    func retriveImage(completion: @escaping (UIImage?) -> ()) {
        guard let imageUrl = movieImageUrl else {
            completion(nil)
            return
        }
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    self.isLoading.value = false
                    completion(image)
                }
                completion(nil)
            }
            completion(nil)
        }
    }
}

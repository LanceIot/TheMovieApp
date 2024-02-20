//
//  MainMovieCellViewMocel.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit

class MainMovieCellViewModel {
    
    var id: Int
    var title: String
    var date: String
    var rating: String
    var imageUrl: String?
    
    init(movie: TrendingMovieModel) {
        self.id = movie.id
        self.title = movie.title ?? movie.name ?? ""
        self.date = movie.releaseDate ?? movie.firstAirDate ?? ""
        self.rating = "\(movie.voteAverage)/10"
        self.imageUrl = movie.posterPath
    }
    
    private func makeImageURL( _ imageCode: String) -> URL? {
        URL(string: "\(NetworkConstant.shared.imageServerAddress)\(imageCode)")
    }
    
    func getImageFromUrl(url: URL, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion(image)
                }
                completion(nil)
            }
            completion(nil)
        }
    }
}

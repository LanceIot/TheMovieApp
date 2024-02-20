//
//  ListMovieModelData.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import Foundation

// MARK: - Welcome
struct ListMovieModelData: Codable {
    let createdBy, description: String
    let favoriteCount, id: Int
    let iso639_1: String
    let itemCount: Int
    let items: [ListMovie]
    let name: String
    let page: Int
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case description
        case favoriteCount = "favorite_count"
        case id
        case iso639_1 = "iso_639_1"
        case itemCount = "item_count"
        case items, name, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Item
struct ListMovie: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let title, originalLanguage, originalTitle, overview: String
    let posterPath, mediaType: String
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

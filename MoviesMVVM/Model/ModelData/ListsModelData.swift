//
//  ListsModel.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import Foundation

// MARK: - Welcome
struct ListsModelData: Codable {
    let page: Int
    let results: [ListResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ListResult: Codable {
    let description: String
    let favoriteCount, id, itemCount: Int
    let iso639_1, listType, name: String

    enum CodingKeys: String, CodingKey {
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case iso639_1 = "iso_639_1"
        case listType = "list_type"
        case name
    }
}

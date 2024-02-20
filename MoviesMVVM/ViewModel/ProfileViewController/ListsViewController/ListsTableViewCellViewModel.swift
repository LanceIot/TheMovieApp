//
//  ListsTableViewCellViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import Foundation

class ListsTableViewCellViewModel {
    
    let description: String
    let favoriteCount, id, itemCount: Int
    let listType, name: String
    
    init(list: ListsModel) {
        self.id = list.id
        self.name = list.name
        self.description = list.description
        self.itemCount = list.itemCount
        self.favoriteCount = list.favoriteCount
        self.listType = list.listType
    }
}

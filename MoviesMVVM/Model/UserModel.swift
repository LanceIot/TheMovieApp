//
//  UserModel.swift
//  MoviesMVVM
//
//  Created by Админ on 22.01.2024.
//

import Foundation

struct UserModel: Codable {
    let requestToken: String
    let sessionID: String
    let accountID: Int
}

//
//  Constants.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit

struct Constants {
    struct Values {        
        static let screenSize = UIScreen.main.bounds.size
        static let mediumSpace = UIScreen.main.bounds.width / 15
        static let smallSpace = UIScreen.main.bounds.width / 35
        static let tinySpace = UIScreen.main.bounds.width / 45
        static let microSpace = UIScreen.main.bounds.width / 90
    }
    
    struct Colors {
        static let mainColor = UIColor.init(red: 26/255, green: 34/255, blue: 50/255, alpha: 1)
        static let navBarColor = UIColor.init(red: 31/255, green: 41/255, blue: 61/255, alpha: 1)
        static let orangeColor = UIColor.init(red: 255/255, green: 128/255, blue: 54/255, alpha: 1)
        static let greyTextColor = UIColor.init(red: 99/255, green: 115/255, blue: 148/255, alpha: 1)
    }
}

enum ContentType: String, CaseIterable {
    case all = "🔥All"
    case movies = "🎬Movies"
    case tv = "📺TV"
}

enum MainContentType: String, CaseIterable {
    case all = "all"
    case movie = "movie"
    case tv = "tv"
}

enum SearchContentType: String, CaseIterable {
    case multi = "multi"
    case movie = "movie"
    case tv = "tv"
}

enum ListContentType: String, CaseIterable {
    case movies = "movies"
    case tv = "tv"
}

enum APICallerEror: Error {
    case cannotGetCredentials
    case cannotFetch
}

enum ListType: String {
    case favorite
    case watchlist
}

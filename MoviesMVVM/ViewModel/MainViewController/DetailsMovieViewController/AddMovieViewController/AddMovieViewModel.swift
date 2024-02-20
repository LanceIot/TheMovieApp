//
//  AddMovieViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 26.01.2024.
//

import Foundation
import UIKit

class AddMovieViewModel {
    
    var movieID: Int?
        
    func addMovieToFavorite(listType: ListType, movieID: Int) {
        let credentials = KeychainManager.shared.getCredentials()
        guard let accountID = credentials.accountDetails?.id,
        let sessionID = credentials.sessionID else {
            return
        }
        
        APICaller.addMovieToFavorite(listType: listType, movieID: movieID, accountID: accountID, sessionID: sessionID) { result in
            switch result {
            case .success(()):
                print()
            case .failure(let error):
                print(error)
            }
        }
    }
}

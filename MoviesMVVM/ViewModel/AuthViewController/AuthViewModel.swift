//
//  ProfileViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 22.01.2024.
//

import Foundation
import UIKit
import SafariServices

class AuthViewModel {
    
    func signIn(completion: @escaping (Result<URL?, NetworkError>) -> ()) {
                
        APICaller.createRequestToken { result in
            switch result {
            case .success(let requestToken):
                print("Fetching Request Token: \(requestToken)")
                
                guard let authorizeURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=demoapp://") else {
                    print("Invalid URL or Request Token not fetched")
                    completion(.failure(.urlError))
                    return
                }

                completion(.success(authorizeURL))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func signUp() ->  SFSafariViewController? {
        let signUpURLString = "https://www.themoviedb.org/signup"
        guard let signUpURL = URL(string: signUpURLString) else { return nil }
        
        let safariViewController = SFSafariViewController(url: signUpURL)
        return safariViewController
    }
    
    func openURLInViewController(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL")
        }
    }
}

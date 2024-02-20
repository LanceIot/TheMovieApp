//
//  APICaller.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation
import UIKit
import SafariServices

enum NetworkError: Error {
    case urlError
    case canNotParseData
}

enum NetworkPostError: Error {
    case urlError
    case serializationError
    case networkError
    case noData
    case apiError
    case jsonParsingError
}

class APICaller {
    
    //MARK: - Trending and search
    
    static func getTrendingMovies(pageNumber: Int = 1, contentType: MainContentType = .all, completion: @escaping (_ result: Result<[TrendingMovieModel], NetworkError>) -> ()) {
        let urlString = "\(NetworkConstant.shared.serverAddress)trending/\(contentType.rawValue)/day?language=en-US&page=\(pageNumber)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var movieList: [TrendingMovieModel] = []
        
        let task = URLSession.shared.dataTask(with: url) { dataResponce, urlResponce, error in
            if error == nil,
                let data = dataResponce,
               let resultData = try? JSONDecoder().decode(TrendingMoviesModel.self, from: data) {
                for model in resultData.results {
                    let movie = TrendingMovieModel(backdropPath: model.backdropPath,
                                                   id: model.id,
                                                   title: model.title,
                                                   originalTitle: model.originalName,
                                                   overview: model.overview,
                                                   popularity: model.popularity,
                                                   posterPath: model.posterPath,
                                                   releaseDate: model.releaseDate,
                                                   voteAverage: model.voteAverage,
                                                   voteCount: model.voteCount,
                                                   name: model.name,
                                                   originalName: model.originalName,
                                                   firstAirDate: model.firstAirDate)
                    movieList.append(movie)
                }
                completion(.success(movieList))
            } else {
                completion(.failure(.canNotParseData))
            }
            
        }
        
        task.resume()
    }
    
    static func searchMovieRequest(contentType: SearchContentType, query: String = "", completion: @escaping ((Result<[TrendingMovieModel], NetworkError>) -> ())) {
        let urlString = "\(NetworkConstant.shared.serverAddress)search/\(contentType.rawValue)?query=\(query)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var movieList: [TrendingMovieModel] = []
        
        let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(TrendingMoviesModel.self, from: data) {
                for model in resultData.results {
                    let movie = TrendingMovieModel(backdropPath: model.backdropPath,
                                                   id: model.id,
                                                   title: model.title,
                                                   originalTitle: model.originalName,
                                                   overview: model.overview,
                                                   popularity: model.popularity,
                                                   posterPath: model.posterPath,
                                                   releaseDate: model.releaseDate,
                                                   voteAverage: model.voteAverage,
                                                   voteCount: model.voteCount,
                                                   name: model.name,
                                                   originalName: model.originalName,
                                                   firstAirDate: model.firstAirDate)
                    movieList.append(movie)
                }
                completion(.success(movieList))
            } else {
                completion(.failure(.canNotParseData))
            }
        }
        task.resume()
    }
    
    //MARK: - Images
    
    static func loadImage(id: String) async -> UIImage? {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + id) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    //MARK: - Auth
    
    static func createRequestToken(completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        let urlString = "\(NetworkConstant.shared.serverAddress)authentication/token/new?api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.urlError))
                return
            }

            if let data = data, let tokenResponse = try? JSONDecoder().decode(RequestTokenResponse.self, from: data) {
                completion(.success(tokenResponse.requestToken))
            } else {
                completion(.failure(.canNotParseData))
            }
        }
        task.resume()
    }
    
    static func createSessionID(requestToken: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let urlString = "\(NetworkConstant.shared.serverAddress)authentication/session/new?api_key=\(NetworkConstant.shared.apiKey)&request_token=\(requestToken)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "api_key": NetworkConstant.shared.apiKey,
            "request_token": requestToken
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(.canNotParseData))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.urlError))
                return
            }
            
            if let data = data, let sessionResponse = try? JSONDecoder().decode(SessionIDResponse.self, from: data) {
                completion(.success(sessionResponse.sessionId))
            } else {
                completion(.failure(.canNotParseData))
            }
        }
        
        task.resume()
    }


    static func getAccountDetails(sessionID: String, completion: @escaping (Result<AccountDetails, Error>) -> Void) {
        let url = URL(string: "\(NetworkConstant.shared.serverAddress)account?api_key=\(NetworkConstant.shared.apiKey)&session_id=\(sessionID)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let accountDetails = try? JSONDecoder().decode(AccountDetails.self, from: data) {
                completion(.success(accountDetails))
            } else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }
    
    //MARK: - User lists
    
    //https://api.themoviedb.org/3/account/{account_id}/favorite/movies?session_id=ec2564cae0cc75c28060bded8d3c03b36feb81b6&api_key=4bf7b5f6aa96f4f873c8a01385c2a5f1
    static func getAccountMovies(accountID: Int, sessionID: String, listType: String, contentType: ListContentType, completion: @escaping (Result<[TrendingMovieModel], NetworkError>) -> ()) {
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/\(listType)/\(contentType.rawValue)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
                
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var movieList: [TrendingMovieModel] = []
        
        let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            if error == nil,
            let data = dataResponse,
               let resultData = try? JSONDecoder().decode(TrendingMoviesModel.self, from: data) {
                for model in resultData.results {
                    let movie = TrendingMovieModel(backdropPath: model.backdropPath,
                                                   id: model.id,
                                                   title: model.title,
                                                   originalTitle: model.originalName,
                                                   overview: model.overview,
                                                   popularity: model.popularity,
                                                   posterPath: model.posterPath,
                                                   releaseDate: model.releaseDate,
                                                   voteAverage: model.voteAverage,
                                                   voteCount: model.voteCount,
                                                   name: model.name,
                                                   originalName: model.originalName,
                                                   firstAirDate: model.firstAirDate)
                    movieList.append(movie)
                }
                completion(.success(movieList))
            } else {
                completion(.failure(.canNotParseData))
            }
        }
        task.resume()
    }
    
    //https://api.themoviedb.org/3/account/{account_id}/lists?session_id=ec2564cae0cc75c28060bded8d3c03b36feb81b6&api_key=4bf7b5f6aa96f4f873c8a01385c2a5f1
    static func getLists(accountID: Int, sessionID: String, completion: @escaping (Result<[ListsModel], NetworkError>) -> ()) {
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/lists?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var lists: [ListsModel] = []
        
        let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListsModelData.self, from: data) {
                for model in resultData.results {
                    let list = ListsModel(description: model.description,
                                          favoriteCount: model.favoriteCount,
                                          id: model.id,
                                          itemCount: model.itemCount,
                                          listType: model.listType,
                                          name: model.name)
                    
                    lists.append(list)
                }
                completion(.success(lists))
            } else {
                completion(.failure(.canNotParseData))
            }
        }
        
        task.resume()
    }
    
    //https://api.themoviedb.org/3/list/8288699?session_id=ec2564cae0cc75c28060bded8d3c03b36feb81b6&api_key=4bf7b5f6aa96f4f873c8a01385c2a5f1
    static func getMoviesFromList(listID: Int, sessionID: String, completion: @escaping (Result<[TrendingMovieModel], NetworkError>) -> ()) {
        let urlString = "\(NetworkConstant.shared.serverAddress)list/\(listID)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var movieList: [TrendingMovieModel] = []
        
        let task = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListMovieModelData.self, from: data) {
                for model in resultData.items {
                    print(model)
                    let movie = TrendingMovieModel(backdropPath: model.backdropPath,
                                                   id: model.id,
                                                   title: model.title,
                                                   originalTitle: model.originalTitle,
                                                   overview: model.overview,
                                                   popularity: model.popularity,
                                                   posterPath: model.posterPath,
                                                   releaseDate: model.releaseDate,
                                                   voteAverage: model.voteAverage,
                                                   voteCount: model.voteCount,
                                                   name: model.title,
                                                   originalName: model.originalTitle,
                                                   firstAirDate: model.releaseDate)
                    movieList.append(movie)
                }
                completion(.success(movieList))
            }
            completion(.failure(.canNotParseData))
        }
        task.resume()
    }
    
    //https://api.themoviedb.org/3/account/{account_id}/favorite?session_id={session_id}}&api_key=4bf7b5f6aa96f4f873c8a01385c2a5f1
    static func addMovieToFavorite(listType: ListType, movieID: Int, accountID: Int, sessionID: String, completion: @escaping (Result<Void, NetworkPostError>) -> ()) {
        
        var listTypeString = ""
        
        switch listType {
        case .favorite:
            listTypeString = "favorite"
        case .watchlist:
            listTypeString = "watchlist"
        default:
            completion(.failure(.urlError))
            return
        }
        
        let urlString = "\(NetworkConstant.shared.serverAddress)account/\(accountID)/\(listTypeString)?session_id=\(sessionID)&api_key=\(NetworkConstant.shared.apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["media_type": "movie", "media_id": movieID, listTypeString: true]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.serializationError))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response here
            // Parse data, check for errors, and call the completion handler accordingly

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            if let error = error {
                print("Error: \(error)")
                completion(.failure(.networkError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                // Check the JSON response and handle accordingly
                // You may want to print or log the JSON for further debugging

                // Example check (adjust based on the actual JSON structure):
                if let success = json?["success"] as? Bool, success {
                    completion(.success(()))
                } else {
                    completion(.failure(.apiError))
                }
            } catch {
                completion(.failure(.jsonParsingError))
            }
        }

        task.resume()
    }

}


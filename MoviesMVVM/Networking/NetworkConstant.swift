//
//  NetworkConstant.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation

class NetworkConstant {
    
    public static var shared: NetworkConstant = NetworkConstant()
    
    private init() {}
    
    public var apiKey: String {
        get {
            return "4bf7b5f6aa96f4f873c8a01385c2a5f1"
        }
    }

    public var serverAddress: String {
        get {
            return "https://api.themoviedb.org/3/"
        }
    }
    
    public var imageServerAddress: String {
        get {
            return "https://image.tmdb.org/t/p/w500/"
        }
    }
}

//
//  AuthenticationManager.swift
//  MoviesMVVM
//
//  Created by Админ on 23.01.2024.
//

import Foundation

protocol AuthenticationManagerDelegate: AnyObject {
    func authenticationStatusDidChange(isAuthenticated: Bool)
}

class AuthenticationManager {
    static let shared = AuthenticationManager()

    weak var delegate: AuthenticationManagerDelegate?

    var isAuthenticated: Bool {
        didSet {
            delegate?.authenticationStatusDidChange(isAuthenticated: isAuthenticated)
        }
    }

    private init() {
        isAuthenticated = false
    }

    func checkAuthentication() {
        let credentials = KeychainManager.shared.getCredentials()

        if let _ = credentials.requestToken,
           let _ = credentials.sessionID,
           let _ = credentials.accountDetails {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}

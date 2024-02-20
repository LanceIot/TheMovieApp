//
//  UserDefaultsManager.swift
//  MoviesMVVM
//
//  Created by Админ on 22.01.2024.
//

import Foundation

class UserDefaultsManager {
    
    // Keys for UserDefaults
    private static let requestTokenKey = "requestToken"
    private static let sessionIDKey = "sessionID"
    private static let accountIDKey = "accountID"
    
    // MARK: - Save to UserDefaults
    
    static func saveRequestToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: requestTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    static func saveSessionID(_ sessionID: String) {
        UserDefaults.standard.set(sessionID, forKey: sessionIDKey)
        UserDefaults.standard.synchronize()
    }
    
    static func saveAccountID(_ accountID: Int) {
        UserDefaults.standard.set(accountID, forKey: accountIDKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Fetch from UserDefaults
    
    static func getRequestToken() -> String? {
        return UserDefaults.standard.string(forKey: requestTokenKey)
    }
    
    static func getSessionID() -> String? {
        return UserDefaults.standard.string(forKey: sessionIDKey)
    }
    
    static func getAccountID() -> Int? {
        return UserDefaults.standard.integer(forKey: accountIDKey)
    }
    
    // MARK: - Remove from UserDefaults
    
    static func clearCredentials() {
        UserDefaults.standard.removeObject(forKey: requestTokenKey)
        UserDefaults.standard.removeObject(forKey: sessionIDKey)
        UserDefaults.standard.removeObject(forKey: accountIDKey)
        UserDefaults.standard.synchronize()
    }
}

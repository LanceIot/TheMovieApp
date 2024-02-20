//
//  KeyChainManager.swift
//  MoviesMVVM
//
//  Created by Админ on 23.01.2024.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager {

    static let shared = KeychainManager()

    private let requestTokenKey = "requestToken"
    private let sessionIDKey = "sessionID"
    private let accountDetailsKey = "accountDetails"

    func saveCredentials(requestToken: String, sessionID: String, accountDetails: AccountDetails) {
        KeychainWrapper.standard.set(requestToken, forKey: requestTokenKey)
        KeychainWrapper.standard.set(sessionID, forKey: sessionIDKey)

        // Сохранение accountDetails в Keychain
        if let accountDetailsData = try? PropertyListEncoder().encode(accountDetails) {
            KeychainWrapper.standard.set(accountDetailsData, forKey: accountDetailsKey)
        }
    }

    func clearCredentials() {
        KeychainWrapper.standard.removeObject(forKey: requestTokenKey)
        KeychainWrapper.standard.removeObject(forKey: sessionIDKey)
        KeychainWrapper.standard.removeObject(forKey: accountDetailsKey)
    }

    func getCredentials() -> (requestToken: String?, sessionID: String?, accountDetails: AccountDetails?) {
        let requestToken = KeychainWrapper.standard.string(forKey: requestTokenKey)
        let sessionID = KeychainWrapper.standard.string(forKey: sessionIDKey)

        // Получение accountDetails из Keychain
        if let accountDetailsData = KeychainWrapper.standard.data(forKey: accountDetailsKey),
            let accountDetails = try? PropertyListDecoder().decode(AccountDetails.self, from: accountDetailsData) {
            return (requestToken, sessionID, accountDetails)
        }

        return (requestToken, sessionID, nil)
    }
}

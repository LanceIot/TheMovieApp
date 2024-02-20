//
//  AppDelegate.swift
//  MoviesMVVM
//
//  Created by Админ on 04.01.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AuthenticationManagerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = Constants.Colors.orangeColor
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        configureApp(window: window)
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func configureApp(window: UIWindow) {
        AuthenticationManager.shared.delegate = self
        AuthenticationManager.shared.checkAuthentication()

        if AuthenticationManager.shared.isAuthenticated {
            let vc = TabBarViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            window.rootViewController = navigationController
        } else {
            let vc = AuthViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            window.rootViewController = navigationController
        }
    }

    // MARK: - AuthenticationManagerDelegate
    func authenticationStatusDidChange(isAuthenticated: Bool) {
        if isAuthenticated {
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                self.window?.rootViewController = UINavigationController(rootViewController: vc)
            }
        } else {
            DispatchQueue.main.async {
                let vc = AuthViewController()
                self.window?.rootViewController = UINavigationController(rootViewController: vc)
            }
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if url.scheme == "demoapp" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                if let requestToken = queryItems.first(where: { $0.name == "request_token" })?.value,
                    let approvedValue = queryItems.first(where: { $0.name == "approved" })?.value,
                    approvedValue.lowercased() == "true" {
                    print(requestToken)
                    APICaller.createSessionID(requestToken: requestToken) { result in
                        switch result {
                        case .success(let sessionID):
                            print(sessionID)
                            APICaller.getAccountDetails(sessionID: sessionID) { result in
                                switch result {
                                case .success(let accountDetails):
                                    self.authenticationStatusDidChange(isAuthenticated: true)
                                    KeychainManager.shared.saveCredentials(requestToken: requestToken, sessionID: sessionID, accountDetails: accountDetails)
                                    print(accountDetails)
                                    print("Checking KeyChain:")
                                    let credentials = KeychainManager.shared.getCredentials()
                                    print("Request Token: \(credentials.requestToken ?? "N/A")")
                                    print("Session ID: \(credentials.sessionID ?? "N/A")")
                                    print("Account Details id: \(credentials.accountDetails?.id)")
                                    print("Account Details username: \(credentials.accountDetails?.username)")
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    authenticationStatusDidChange(isAuthenticated: false)
                }
            }
            return true
        }
        return false
    }
}

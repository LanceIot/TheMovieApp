//
//  ProfileViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 23.01.2024.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    var accountDetails: Obsorvable<AccountDetails> = Obsorvable(nil)
    
    func getAccountDetails() {
        let credentials = KeychainManager.shared.getCredentials()
        self.accountDetails.value = credentials.accountDetails
    }
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int = 1) -> Int {
        return 4
    }
    
    func getHeightForRow() -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }
}

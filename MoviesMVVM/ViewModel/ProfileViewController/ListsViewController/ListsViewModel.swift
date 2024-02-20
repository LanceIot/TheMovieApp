//
//  ListsViewModel.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import Foundation
import UIKit

class ListsViewModel {
    
    var isLoading: Obsorvable<Bool> = Obsorvable(false)
    var cellDataSource: Obsorvable<[ListsTableViewCellViewModel]> = Obsorvable(nil)
    var dataSources: [ListsModel] = []
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int = 1) -> Int {
        return dataSources.count
    }
    
    func getHeightForRow(indexPath: IndexPath) -> CGFloat {
        
        let name = dataSources[indexPath.row].name
        let description = dataSources[indexPath.row].description
        
        print(name)
        print(description)
        
        let nameHeight = heightForLabel(text: name, fontSize: 20)
        let descriptionHeight = heightForLabel(text: description, fontSize: 14)
        
        return nameHeight + descriptionHeight
    }
    
    func heightForLabel(text: String, fontSize: CGFloat) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.sizeToFit()
        return textView.frame.height
    }
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSources.compactMap({ListsTableViewCellViewModel(list: $0)})
    }
    
    func getData(completion: ((Result<Void, APICallerEror>) -> Void)? = nil) {
        
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        let credentials = KeychainManager.shared.getCredentials()
        guard let accountID = credentials.accountDetails?.id,
        let sessionID = credentials.sessionID else {
            completion?(.failure(.cannotGetCredentials))
            isLoading.value = false
            return
        }
        
        APICaller.getLists(accountID: accountID, sessionID: sessionID) { [weak self] result in
            self?.isLoading.value = false
            
            switch result {
            case .success(let lists):
                self?.dataSources.append(contentsOf: lists)
                self?.mapCellData()
                completion?(.success(()))
            case .failure(let error):
                print("Cant fetch lists: \(error)")
                completion?(.failure(.cannotFetch))
            }
        }
    }
}

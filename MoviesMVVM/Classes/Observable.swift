//
//  Observable.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import Foundation

class Obsorvable<T> {
    
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init( _ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> ())?
    
    func bind( _ listener: @escaping ((T?) -> ())) {
        listener(value)
        self.listener = listener
    }
}

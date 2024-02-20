//
//  ListViewController+SegmentController.swift
//  MoviesMVVM
//
//  Created by Админ on 04.02.2024.
//

import Foundation
import UIKit

extension ListViewController {
    
    func setupSegmentController() {
        listSegmentControll.selectedSegmentIndex = 0
        listSegmentControll.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.selectedContentType = .movies
        case 1:
            viewModel.selectedContentType = .tv
        default:
            viewModel.selectedContentType = .movies
        }
        viewModel.removeData()
        viewModel.getData()
    }
}

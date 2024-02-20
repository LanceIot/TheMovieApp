//
//  MainViewController+CollectionView.swift
//  MoviesMVVM
//
//  Created by Админ on 17.01.2024.
//

import Foundation
import UIKit

extension MainViewController {
    
    func setupCollectionView() {
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
        
        self.mainCollectionView.backgroundColor = .clear
        self.registerCollectionViewCells()
    }
    
    func registerCollectionViewCells() {
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView data source methods
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.allContentTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        cell.setupCell(with: viewModel.allContentTypes[indexPath.row].rawValue, isSelected: viewModel.isCollectionViewSelected(indexPath: indexPath.row))
        cell.round()
        return cell
    }
}

//MARK: - UICollectionView delegate methods
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = viewModel.allContentTypes[indexPath.row].rawValue
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return CGSize(width: label.frame.size.width + 80, height: collectionView.frame.size.height - 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCell = indexPath.item
        switch indexPath.item {
        case 0:
            viewModel.removeDataAfterSelectedCell(contentType: .all)
        case 1:
            viewModel.removeDataAfterSelectedCell(contentType: .movie)
        default:
            viewModel.removeDataAfterSelectedCell(contentType: .tv)
        }
        viewModel.getData()
        reloadCollectionView()
        reloadTableView()
    }
}

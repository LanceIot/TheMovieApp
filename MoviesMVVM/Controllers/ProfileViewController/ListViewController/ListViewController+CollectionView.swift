//
//  ListViewController+CollectionView.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import Foundation
import UIKit

extension ListViewController {
    func setupCollectionView() {
        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.backgroundColor = Constants.Colors.mainColor
        registerCells()
    }
    
    func registerCells() {
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.listCollectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView data source methods
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellViewModel = cellDataSource[indexPath.row]
        cell.configure(viewModel: cellViewModel, collectionView: collectionView, indexPath: indexPath)
        cell.round()
        return cell
    }
}

//MARK: - UICollectionView delegate methods
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getSizeForItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = DetailsMovieViewModel(movie: viewModel.dataSources[indexPath.item])
        let vc = DetailsMovieViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

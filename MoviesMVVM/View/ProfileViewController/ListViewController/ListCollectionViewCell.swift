//
//  ListCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static public var identifier: String {
        get {
            return "ListCollectionViewCell"
        }
    }
    
    lazy var movieImageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    func configure(viewModel: ListCollectionViewCellViewModel, collectionView: UICollectionView, indexPath: IndexPath) {
        Task {
            if let imgUrl = viewModel.imageUrl, let image = await APICaller.loadImage(id: imgUrl) {
                DispatchQueue.main.async { [weak self] in
                    if self == collectionView.cellForItem(at: indexPath) {
                        self?.movieImageView.image = image
                    }
                }
            }
        }
    }
}

//MARK: - Setup view and contraints methods
private extension ListCollectionViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(movieImageView)
    }
    
    func setupConstraints() {
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

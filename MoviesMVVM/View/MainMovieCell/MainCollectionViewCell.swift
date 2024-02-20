//
//  MainCollectionViewCell.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    public static var identifier: String {
        get {
            return "MainCollectionViewCell"
        }
    }
    
    var isSelectedCell: Bool = false {
        didSet {
            updateSelectedState()
        }
    }
    
    lazy var contentTypeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.Colors.navBarColor
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contentTypeLabel.text = ""
        backgroundColor = Constants.Colors.navBarColor
        isSelected = false
    }
    
    func setupCell(with text: String, isSelected: Bool) {
            contentTypeLabel.text = text
            isSelectedCell = isSelected
    }
    
    private func updateSelectedState() {
        if isSelectedCell {
            contentView.backgroundColor = Constants.Colors.orangeColor
        } else {
            contentView.backgroundColor = .clear
        }
    }
}

//MARK: - Setup view and contraints methods
private extension MainCollectionViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(contentTypeLabel)
    }
    
    func setupConstraints() {
        contentTypeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

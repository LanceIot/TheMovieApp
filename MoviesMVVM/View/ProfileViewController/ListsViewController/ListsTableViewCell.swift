//
//  ListsTableViewCell.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import UIKit

class ListsTableViewCell: UITableViewCell {
    
    static public var identifier: String {
        get {
            return "ListsTableViewCell"
        }
    }
    
    lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var listNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var rightView: UIView = {
       let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    lazy var listCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var listImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var listDescriptionTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .blue
        textView.isUserInteractionEnabled = false
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Constants.Colors.navBarColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(listViewModel: ListsTableViewCellViewModel) {
        listNameLabel.text = listViewModel.name
        listCountLabel.text = "\(listViewModel.itemCount)"
        listDescriptionTextView.text = listViewModel.description
    }
}

//MARK: - Setup view and contraints methods
private extension ListsTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(topView)
        topView.addSubview(listNameLabel)
        topView.addSubview(rightView)
        rightView.addSubview(listCountLabel)
        rightView.addSubview(listImageView)
        contentView.addSubview(listDescriptionTextView)
    }
    
    func setupConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Values.tinySpace)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(listNameLabel.snp.height)
        }
        listNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Values.smallSpace)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        rightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
            make.centerY.equalToSuperview()
        }
        listCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        listImageView.snp.makeConstraints { make in
            make.leading.equalTo(listCountLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        listDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview().inset(Constants.Values.tinySpace)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

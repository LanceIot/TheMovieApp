//
//  ProfileTableViewCell.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "ProfileTableViewCell"
        }
    }
    
    //MARK: - UI
    lazy var wholeView: UIView = {
       let view = UIView()
        view.round()
        view.backgroundColor = Constants.Colors.navBarColor
        return view
    }()
    
    lazy var profileLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(labelText: String) {
        self.profileLabel.text = labelText
    }
}

//MARK: - Setup view and contraints methods
private extension ProfileTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(wholeView)
        wholeView.addSubview(profileLabel)
        wholeView.addSubview(profileImageView)
    }
    
    func setupConstraints() {
        wholeView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Values.tinySpace)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
        }
        profileLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Values.mediumSpace)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.Values.mediumSpace)
            make.centerY.equalToSuperview()
        }
    }
}

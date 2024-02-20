//
//  SearchTableViewCell.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "SearchTableViewCell"
        }
    }
    
    //MARK: - UI
    
    lazy var wholeView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var movieImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.round()
        return imageView
    }()
    
    lazy var textView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Constants.Colors.navBarColor
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
    func setupCell(viewModel: SearchTableViewCellViewModel, tableView: UITableView, indexPath: IndexPath) {
        Task {
            if let imgUrl = viewModel.imageUrl, let image = await APICaller.loadImage(id: imgUrl) {
                DispatchQueue.main.async { [weak self] in
                    if self == tableView.cellForRow(at: indexPath) {
                        self?.movieImageView.image = image
                    }
                }
            }
        }
        self.titleLabel.text = viewModel.title
        let year = String(viewModel.date.prefix(4))
        self.dateLabel.text = year
    }
}

//MARK: - Setup view and contraints methods
private extension SearchTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(wholeView)
        wholeView.addSubview(movieImageView)
        wholeView.addSubview(textView)
        textView.addSubview(titleLabel)
        textView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        wholeView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.Values.smallSpace)
        }
        movieImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.13)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(movieImageView.snp.trailing).offset(Constants.Values.smallSpace)
            make.top.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
    }
}

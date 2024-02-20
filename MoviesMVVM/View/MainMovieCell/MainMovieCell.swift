//
//  MainMovieCell.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import UIKit

class MainMovieCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "MainMovieCell"
        }
    }
    
    //MARK: - UI
    private lazy var wholeView: UIView = {
       let view = UIView()
        view.backgroundColor = Constants.Colors.navBarColor
        view.round()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.round()
        return imageView
    }()
    
    private lazy var textView: UIView = {
       let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Constants.Colors.mainColor
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        mainImageView.image = nil
    }
    
    func setupCell(viewModel: MainMovieCellViewModel, tableView: UITableView, indexPath: IndexPath) {
        Task {
            if let imgUrl = viewModel.imageUrl, let image = await APICaller.loadImage(id: imgUrl) {
                DispatchQueue.main.async { [weak self] in
                    if self == tableView.cellForRow(at: indexPath) {
                        self?.mainImageView.image = image
                    }
                }
            }
        }
        self.titleLabel.text = viewModel.title
        self.dateLabel.text = viewModel.date
        self.ratingLabel.text = viewModel.rating
    }
}

//MARK: - Setup view and contraints methods
private extension MainMovieCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(wholeView)
        wholeView.addSubview(mainImageView)
        wholeView.addSubview(textView)
        textView.addSubview(titleLabel)
        textView.addSubview(dateLabel)
        textView.addSubview(ratingLabel)
    }
    
    func setupConstraints() {
        wholeView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(5)
            make.top.trailing.bottom.equalToSuperview().inset(5)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)

        }
    }
}

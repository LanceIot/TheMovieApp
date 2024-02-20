//
//  AddMovieViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import UIKit

class AddMovieViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    var viewModel: AddMovieViewModel = AddMovieViewModel()
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var yearLabel: UILabel = {
       let label = UILabel()
        label.text = "Unknow year"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var wholeView: UIView = {
       let view = UIView()
        view.backgroundColor = Constants.Colors.navBarColor
        view.round()
        return view
    }()
    
//    lazy var buttonsStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.spacing = Constants.Values.smallSpace
//        return stackView
//    }()
    
    lazy var buttonsView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var listButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
//        button.setTitle("Add To List", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
//        button.setTitle("Like", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var watchlistButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "clock"), for: .normal)
//        button.setTitle("Watchlist", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(watchlistButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configure(title: String, year: String?) {
        self.titleLabel.text = title
        if let year {
            let yearString = String(year.prefix(4))
            self.yearLabel.text = yearString
        }
    }
}

//MARK: - ViewController methods
extension AddMovieViewController {
    
    func configureView() {
        
        sheetPresentationController.detents = [
            .medium()
        ]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.delegate = self
        
        view.backgroundColor = Constants.Colors.mainColor
        
        setupUI()
    }
    
    @objc func listButtonTapped() {
        print("List button tapped")
    }
    
    @objc func favoriteButtonTapped() {
        guard let id = viewModel.movieID else { return }
        
        viewModel.addMovieToFavorite(listType: .favorite, movieID: id)
        self.dismiss(animated: true)
    }
    
    @objc func watchlistButtonTapped() {
        guard let id = viewModel.movieID else { return }
        
        viewModel.addMovieToFavorite(listType: .watchlist, movieID: id)
        self.dismiss(animated: true) 
    }
}

//MARK: - Setup view and contraints methods
private extension AddMovieViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(yearLabel)
        view.addSubview(wholeView)
        wholeView.addSubview(buttonsView)
        buttonsView.addSubview(listButton)
        buttonsView.addSubview(favoriteButton)
        buttonsView.addSubview(watchlistButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Values.mediumSpace)
            make.leading.trailing.equalToSuperview()
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Values.tinySpace)
            make.leading.trailing.equalToSuperview()
        }
        wholeView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(Constants.Values.smallSpace)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        buttonsView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.Values.mediumSpace)
        }
        listButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        listButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.Values.mediumSpace)
        }
        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(listButton.snp.trailing)
            make.width.equalToSuperview().dividedBy(3)
            make.top.bottom.equalToSuperview()
        }
        favoriteButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.Values.mediumSpace)
        }
        watchlistButton.snp.makeConstraints { make in
            make.leading.equalTo(favoriteButton.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
        watchlistButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.Values.mediumSpace)
        }
    }
}

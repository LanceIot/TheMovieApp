//
//  MainViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel = MainViewModel()
    var cellDataSource: [MainMovieCellViewModel] = []
    
    lazy var mainCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var mainTableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var tableViewActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        viewModel.getData()
//    }
}

//MARK: - View Controller methods
extension MainViewController {
    
    func configureView() {
        view.backgroundColor = Constants.Colors.mainColor
        navigationController?.navigationBar.backgroundColor = Constants.Colors.mainColor
        title = "Movies"
        
        viewModel.getData()
        bindViewModel()
        setupUI()
        setupCollectionView()
        setupTableView()
    }
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.cellDataSource.bind { [weak self] movies in
            guard let self = self, let movies else { return }
            
            self.cellDataSource = movies
            self.reloadTableView()
        }
    }
    
    func openDetails(movieId: Int) {
        guard let movie = viewModel.retriveMovie(by: movieId) else { return }
        let detailsViewModel = DetailsMovieViewModel(movie: movie)
        let detailsController = DetailsMovieViewController(viewModel: detailsViewModel)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailsController, animated: true)
        }
    }
}

//MARK: - Setup view and contraints methods
private extension MainViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(mainCollectionView)
        view.addSubview(mainTableView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
            make.height.equalTo(view).multipliedBy(0.06)
        }
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(Constants.Values.smallSpace)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

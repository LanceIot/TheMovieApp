//
//  SearchViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel = SearchViewModel()
    var cellDataSource: [SearchTableViewCellViewModel] = []
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search movies or tv shows"
        controller.searchBar.scopeButtonTitles = ContentType.allCases.map { $0.rawValue }
        return controller
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var searchTableView: UITableView = {
       let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
    }
}

//MARK: - View Controller methods
extension SearchViewController {
    func configureVC() {
        self.view.backgroundColor = Constants.Colors.mainColor
        self.navigationController?.navigationBar.backgroundColor = Constants.Colors.mainColor
        self.title = "Search"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = true
    
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        bindViewModel()
        setupSearchTableView()
        setupUI()
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
            guard let self, let movies else { return }
            
            self.cellDataSource = movies
            self.reloadTableView()
        }
        
        viewModel.query.bind { [weak self] _ in
            guard let self else { return }

            self.viewModel.getData()
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
private extension SearchViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(searchTableView)
    }
    
    func setupConstraints() {
        self.navigationController?.view.frame.origin.y = view.safeAreaInsets.top
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

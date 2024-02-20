//
//  ListsViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 25.01.2024.
//

import UIKit

class ListsViewController: UIViewController {
    
    var viewModel = ListsViewModel()
    var cellDataSource: [ListsTableViewCellViewModel] = []
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var listsTableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

//MARK: - ViewController methods
extension ListsViewController {
    
    func configureView() {
        view.backgroundColor = Constants.Colors.mainColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Lists"
        
        viewModel.getData()
        bindViewModel()
        setupUI()
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
        
        viewModel.cellDataSource.bind { [weak self] lists in
            guard let self, let lists else { return }
            
            self.cellDataSource.append(contentsOf: lists)
            self.reloadTableView()
        }
    }
}

//MARK: - Setup view and contraints methods
private extension ListsViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(listsTableView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        listsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

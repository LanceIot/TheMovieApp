//
//  ListViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 24.01.2024.
//

import UIKit

class ListViewController: UIViewController {
    
    var viewModel: ListViewModel = ListViewModel()
    var cellDataSource: [ListCollectionViewCellViewModel] = []
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var listSegmentControll: UISegmentedControl = {
        let segmentControll = UISegmentedControl(items: [ContentType.movies.rawValue, ContentType.tv.rawValue])
        return segmentControll
    }()

    lazy var listCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
}

//MARK: - ViewController methods
extension ListViewController {
    
    func configureView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Lists"
        view.backgroundColor = Constants.Colors.mainColor
        viewModel.getData()
        bindViewModel()
        setupUI()
        setupCollectionView()
        setupSegmentController()
    }
    
    func bindViewModel() {
        viewModel.cellDataSource.bind { [weak self] viewModels in
            guard let self, let viewModels else { return }
            
            self.cellDataSource = viewModels
            self.reloadCollectionView()
        }
        
        viewModel.typeOfList.bind { [weak self] listType in
            guard let self, let listType else { return }
            
            switch listType {
            case .favorite:
                self.title = "Favorites"
            case .watchlist:
                self.title = "Watchlist"
            }
        }
        
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
    }
}

//MARK: - Setup view and contraints methods
private extension ListViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(listSegmentControll)
        view.addSubview(listCollectionView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        listSegmentControll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.Values.smallSpace)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
        }
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listSegmentControll.snp.bottom).offset(Constants.Values.smallSpace)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
            make.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

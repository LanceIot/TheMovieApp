//
//  ProfileViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 23.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel = ProfileViewModel()
    
    lazy var profileTableView: UITableView = {
      let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
}

//MARK: - ViewController methods
extension ProfileViewController {
    
    func configureView() {
        
        view.backgroundColor = Constants.Colors.navBarColor
        navigationController?.navigationBar.backgroundColor = Constants.Colors.mainColor
        
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        setupUI()
        bindViewModel()
        viewModel.getAccountDetails()
        setupTableView()
    }
    
    func bindViewModel() {
        viewModel.accountDetails.bind { accountDetails in
            self.title = accountDetails?.username
        }
    }
    
    @objc func leftBarButtonTapped() {
        
    }
    
    @objc func rightBarButtonTapped() {
        AuthenticationManager.shared.isAuthenticated = false
        KeychainManager.shared.clearCredentials()
    }
}

//MARK: - Setup view and contraints methods
private extension ProfileViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(profileTableView)
    }
    
    func setupConstraints() {
        profileTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//
//  ProfileViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 21.01.2024.
//

import UIKit
import WebKit
import SafariServices

class AuthViewController: UIViewController {
    
    var viewModel: AuthViewModel = AuthViewModel()
        
    lazy var signInButton: UIButton = {
       let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.round()
        button.backgroundColor = Constants.Colors.orangeColor
        button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton: UIButton = {
       let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.round()
        button.backgroundColor = Constants.Colors.orangeColor
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth Page"
        navigationController?.navigationBar.backgroundColor = Constants.Colors.navBarColor
        view.backgroundColor = Constants.Colors.mainColor
        
        setupUI()
    }
}

//MARK: - ViewController methods
extension AuthViewController {
    
    @objc func signInPressed() {
        viewModel.signIn { result in
            switch result {
            case .success(let url):
                guard let url else { return }
                DispatchQueue.main.async {
                    self.viewModel.openURLInViewController(url: url)
                }
            case .failure(_):
                print("Sign In error in ProfileVC")
            }
        }
    }
    
    @objc func signUpPressed() {
        guard let vc = viewModel.signUp() else { return }
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Setup view and contraints methods
private extension AuthViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    func setupConstraints() {
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.bounds.height / 4)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(Constants.Values.smallSpace)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.leading.trailing.equalToSuperview().inset(Constants.Values.smallSpace)
        }
    }
}

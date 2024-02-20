//
//  DetailsMovieViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 15.01.2024.
//

import UIKit

class DetailsMovieViewController: UIViewController {
    
    var viewModel: DetailsMovieViewModel
    
    init(viewModel: DetailsMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = view.bounds
        return blurEffectView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var textView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white.withAlphaComponent(0.4)
       return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
       let textView = UITextView()
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

//MARK: - View private methods
extension DetailsMovieViewController {
    func configureView() {
        setupUI()
        
        self.title = "Movie Detail"
        view.backgroundColor = Constants.Colors.mainColor
        
        bindViewModel()
        setTabBarButtons()
    }
    
    func setTabBarButtons() {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped() {
        let vc = AddMovieViewController()
        vc.viewModel.movieID = viewModel.movie.id
        vc.configure(title: viewModel.movieTitle, year: viewModel.movie.releaseDate)
        self.present(vc, animated: true)
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
        
        viewModel.retriveImage(completion: { [self] image in
            
            DispatchQueue.main.async {
                self.titleLabel.text = self.viewModel.movieTitle
                self.descriptionTextView.text = "\t\(self.viewModel.movieDescription)"
            }
            
            guard let image else {
                self.viewModel.isLoading.value = false
                return
            }
            
            DispatchQueue.main.async {
                self.movieImageView.image = image
                self.viewModel.isLoading.value = false
            }
        })
    }
}

//MARK: - Setup view and contraints methods
private extension DetailsMovieViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(movieImageView)
        movieImageView.addSubview(activityIndicator)
        view.addSubview(textView)
        textView.addSubview(titleLabel)
        textView.addSubview(descriptionTextView)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//
//  FullPost.swift
//  Navigation
//
//  Created by Maksim Maiorov on 18.03.2022.
//

import UIKit

class FullPostView: UIView {
    
    // MARK: - PROPERTIES
    
    struct ViewModel: ViewModelProtocol { // MODEL
        var author: String
        var description: String
        var image: String
        var likes: Int
        var views: Int
    }
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var authorLabel: UILabel = { // ЗАГОЛОВОК
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.textColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = { // PHOTO
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        //        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = { // НОВОСТЬ
        let label = UILabel()
        label.backgroundColor = .clear
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var likeTitle: UILabel = { // ЛАЙКИ
        let label = UILabel()
        label.text = "Likes: "
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.textColor = .black
        label.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var viewTitle: UILabel = { // ПРОСМОТРЫ
        let label = UILabel()
        label.text  = "Views: "
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.textColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var transitionButton: UIButton = {  // КНОПКА ВОЗВРАТА
        let button = UIButton()
        let image = UIImage(named: "cancel")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - LIFECIRCLE METHODS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP SUBVIEWS
    
    private func setupView() {
        self.addSubview(self.mainView)
        self.addSubview(self.transitionButton)
        self.mainView.addSubview(self.backView)
        self.backView.addSubview(self.authorLabel)
        self.backView.addSubview(self.postImageView)
        self.backView.addSubview(self.descriptionLabel)
        self.backView.addSubview(self.likeStackView)
        self.likeStackView.addArrangedSubview(self.likeTitle)
        self.likeStackView.addArrangedSubview(self.viewTitle)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            self.mainView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.backView.centerXAnchor.constraint(equalTo: self.mainView.centerXAnchor),
            self.backView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            self.backView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            self.backView.centerYAnchor.constraint(equalTo: self.mainView.centerYAnchor),
            
            self.authorLabel.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 16),
            self.authorLabel.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 16),
            self.authorLabel.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -16),
            
            self.postImageView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 12),
            self.postImageView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor),
            self.postImageView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor),
            self.postImageView.heightAnchor.constraint(equalTo: self.backView.widthAnchor, multiplier: 1.0),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 16),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -16),
            
            self.likeStackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.likeStackView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 16),
            self.likeStackView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -16),
            self.likeStackView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -16),
            
            self.transitionButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.transitionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.transitionButton.heightAnchor.constraint(equalToConstant: 40),
            self.transitionButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func clickButton() {  // возвращение к родительскому ViewController
        removeFromSuperview()
    }
}

// MARK: - EXTENSIONS

extension FullPostView: Setupable { // MODEL
    
    func setup(with viewModel: ViewModelProtocol) { //
        guard let viewModel = viewModel as? ViewModel else { return }
        
        self.authorLabel.text = viewModel.author
        self.postImageView.image = UIImage(named: viewModel.image)
        self.descriptionLabel.text = viewModel.description
        self.likeTitle.text = "Likes: " + String(viewModel.likes)
        self.viewTitle.text = "Views: " + String(viewModel.views)
    }
}

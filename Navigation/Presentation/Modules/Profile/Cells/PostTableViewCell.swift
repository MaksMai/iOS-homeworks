//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import UIKit

// MARK: - PROTOCOLS

protocol PostTableViewCellProtocol: AnyObject {
//    func updateViews(at: IndexPath, with: News, cell: PostTableViewCell)
    func delegateLabelAction(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    // MARK: - PROPERTIES
    
    weak var delegate: PostTableViewCellProtocol? // DELEGAT
    
    private var tapGestureRecognizer = UITapGestureRecognizer() // НАЖАТИЕ
    
    struct ViewModel: ViewModelProtocol { // МОДЕЛЬ ДАННЫХ ПОСТА
        var author: String
        var description: String
        var image: String
        var likes: Int
        var views: Int
    }
    
    private lazy var authorLabel: UILabel = { // ЗАГОЛОВОК
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.textColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = { // ФОТО
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = { // НОВОСТИ
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
    
    private lazy var likeStackView: UIStackView = { // СТЭК ЛАЙКИ И ПРОСМОТРЫ
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var likeTitle: UILabel = { // ЛАЙКИ
        let label = UILabel()
        label.text  = "Likes: "
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.preferredMaxLayoutWidth = self.frame.size.width
        label.textColor = .black
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // MARK: - LIFECYCLE METHODS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() { // обнуление информации в ячейках
        super.prepareForReuse()
        self.authorLabel.text = nil
        self.postImageView.image = nil
        self.descriptionLabel.text = nil
        self.likeTitle.text = nil
        self.viewTitle.text = nil
    }
    
    // MARK: - SETUP SUBVIEWS
    
    private func setupView() {
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.likeStackView)
        self.likeStackView.addArrangedSubview(self.likeTitle)
        self.likeStackView.addArrangedSubview(self.viewTitle)
        setupConstraints()
        setupGesture()
    }
    
    private func setupConstraints() {
        let topConstraintAuthorLabel = self.authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        let leadingConstraintAuthorLabel = self.authorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        let trailingConstraintAuthorLabel = self.authorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        let topConstraintPostImageView = self.postImageView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 12)
        let leadingConstraintPostImageView = self.postImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let trailingConstraintPostImageView = self.postImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let widthPostImageView = self.postImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1.0)
        let topConstraintDescriptionLabel = self.descriptionLabel.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 16)
        let leadingConstraintDescriptionLabell = self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        let trailingConstraintDescriptionLabel = self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        let topConstraintLikeStackView = self.likeStackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16)
        let leadingConstraintLikeStackView = self.likeStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        let trailingConstraintLikeStackView = self.likeStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        let bottomConstraintLikeStackView = self.likeStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            topConstraintAuthorLabel, topConstraintPostImageView,widthPostImageView,
            leadingConstraintAuthorLabel, trailingConstraintAuthorLabel,
            topConstraintDescriptionLabel, leadingConstraintDescriptionLabell,
            trailingConstraintDescriptionLabel, topConstraintLikeStackView,
            leadingConstraintLikeStackView, trailingConstraintLikeStackView,
            bottomConstraintLikeStackView, leadingConstraintPostImageView,
            trailingConstraintPostImageView
        ])
    }
}

// MARK: - EXTENSIONS

extension PostTableViewCell: Setupable { // СОЗДАЕМ МОДЕЛЬ ДАННЫХ
    
    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        
        self.authorLabel.text = viewModel.author
        self.postImageView.image = UIImage(named: viewModel.image)
        self.descriptionLabel.text = viewModel.description
        self.likeTitle.text = "Likes: " + String(viewModel.likes)
        self.viewTitle.text = "Views: " +  String(viewModel.views)
    }
}

extension PostTableViewCell { // TAP
    
//    private func setupTapGesture() {
//        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleTapGesture(_:)))
//        self.postImageView.addGestureRecognizer(self.tapGestureRecognizer)
//        self.postImageView.isUserInteractionEnabled = true
//    }
//
//    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
//        guard self.tapGestureRecognizer === gestureRecognizer else { return }
//
//        guard var news = self.news,
//              let indexPath = self.indexPath
//        else { return }
//
//        news.views += 1
//
//        self.viewTitle.text = "Views: \(news.views)"
//        let newModel = News(author: news.author, description: news.description, image: news.image, likes: news.views, views: news.views)
//
//        delegate?.updateViews(at: indexPath, with: newModel, cell: self)
//
//    }
    
    private func setupGesture() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleGesture(_:)))
        self.likeTitle.addGestureRecognizer(self.tapGestureRecognizer)
        self.likeTitle.isUserInteractionEnabled = true
    }
    
    @objc func handleGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.tapGestureRecognizer === gestureRecognizer else { return }
        delegate?.delegateLabelAction(cell: self)
    }
}

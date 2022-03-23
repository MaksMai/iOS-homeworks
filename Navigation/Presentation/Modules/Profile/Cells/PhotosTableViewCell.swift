//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Maksim Maiorov on 28.02.2022.
//

import UIKit

// MARK: - PROTOCOLS

protocol PhotosTableViewCellProtocol: AnyObject { // протокол делегата управления кнопкой
    func delegateButtonAction(cell: PhotosTableViewCell)
}

// MARK: - PROPERTIES

class PhotosTableViewCell: UITableViewCell {
    
    private enum Constant {  // количество ячеек в коллекшин вью
        static let itemCount: CGFloat = 4
    }
    
    weak var delegate: PhotosTableViewCellProtocol? // делегат управления кнопкой
    
    private lazy var backView: UIView = { // контейнер интерфейсов
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {  // Создаем стек для фото
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {   // Устанавливаем метку имени
        let label = UILabel() // Создаем метку
        label.text  = "Photos" // Именуем метку
        label.textColor = .black // цвет текста
        label.font = UIFont.boldSystemFont(ofSize: 24.0) // тольщина и размер текста
        label.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        
        return label
    }()
    
    private lazy var transitionButton: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()
        let image = UIImage(named: "arrow")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
        button.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        
        return button
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        
        return layout
    }()
    
    private lazy var photoCollectionView: UICollectionView = {  // Создаем  фото
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollection")
        stackView.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
        
        return collectionView
    }()
    
    // MARK: LIFECYCLE METHODS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView() // устанавливаем интерфейс
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP SUBVIEW
    
    private func setupView() { 
        self.backgroundColor = .systemGray6
        self.contentView.addSubview(self.backView)
        self.backView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.transitionButton)
        self.backView.addSubview(photoCollectionView)
        setupConstraints()
    }
    
    // MARK: - SETUP SUBVIEW
    
    private func setupConstraints() {
        let topConstraint = self.backView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        let leadingConstraint = self.backView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let trailingConstraint = self.backView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let bottomConstraint = self.backView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        
        let stackViewTopConstraint = self.stackView.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 12)
        let stackViewLeadingConstraint = self.stackView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 12)
        let stackViewTrailingConstraint = self.stackView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -12)
        
        let transitionButtonHeight = self.transitionButton.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 1)
        
        let photoCollectionViewTopConstraint = self.photoCollectionView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor)
        let photoCollectionViewLeadingConstraint = self.photoCollectionView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 12)
        let photoCollectionViewTrailingConstraint = self.photoCollectionView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -12)
        let photoCollectionViewConstraint = self.photoCollectionView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -12)
        let photoCollectionViewHeight = self.photoCollectionView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, bottomConstraint, trailingConstraint,
            stackViewTopConstraint, stackViewLeadingConstraint, stackViewTrailingConstraint,
            photoCollectionViewTopConstraint, photoCollectionViewLeadingConstraint,
            photoCollectionViewTrailingConstraint, photoCollectionViewConstraint,
            photoCollectionViewHeight, transitionButtonHeight
        ])
    }
    
    @objc private func buttonAction() {  // Действие кнопки
        delegate?.delegateButtonAction(cell: self) // передаем управление нажатием в ячейку тайбл вью
    }
    
    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize { // размеры ячейки
        let needWidth = width - 2 * spacing
        let itemWidth = floor(needWidth / Constant.itemCount)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - EXTENSIONS

extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return carImage.count // количество картинок в коллектион вью
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollection", for: indexPath) as! PhotosCollectionViewCell
        
        DispatchQueue.main.async { // загружаем картинку вo вью картинок
            let car = carImage[indexPath.row]
            let viewModel = PhotosCollectionViewCell.ViewModel(image: car.image)
            cell.setup(with: viewModel)
        }
        
        return cell
    }
}

extension PhotosTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // количество и размеры картинок
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        
        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
    }
}


//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 02.03.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private enum Constant {
        static let itemCount: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        return layout
    }()
    
    private lazy var photoCollectionView: UICollectionView = {  // ФОТО
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollection")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Photo Gallery"
    }
    
    // MARK: - SETUP SUBVIEWS
    
    private func setupCollectionView() {
        self.view.addSubview(self.photoCollectionView)
        
        let topConstraint = self.photoCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
        ])
    }
    
    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
        let needWidth = width - 5 * spacing
        let itemWidth = floor(needWidth / Constant.itemCount)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

    // MARK: - EXTENSIONS

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return carImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollection", for: indexPath) as! PhotosCollectionViewCell
        
            let car = carImage[indexPath.row]
            let viewModel = PhotosCollectionViewCell.ViewModel(image: car.image)
            cell.setup(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // количество и размеры картинок
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing
        
        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animatedPhotoViewController = AnimatedPhotoViewController()
        
        let car = carImage[indexPath.row]
        let viewModel = AnimatedPhotoViewController.ViewModel(image: car.image)
        animatedPhotoViewController.setup(with: viewModel)
        
        self.view.addSubview(animatedPhotoViewController.view)
        self.addChild(animatedPhotoViewController)
        animatedPhotoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedPhotoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedPhotoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedPhotoViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            animatedPhotoViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.navigationController?.navigationBar.isHidden = true
        animatedPhotoViewController.didMove(toParent: self)
    }
}

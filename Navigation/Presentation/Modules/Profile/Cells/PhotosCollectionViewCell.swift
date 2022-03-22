//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Maksim Maiorov on 01.03.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    struct ViewModel: ViewModelProtocol {
        var image: String
    }
    
    let photoView: UIImageView = {  // PHOTO
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: LIFECYCLE METHODS
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupPhotoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP SUBVIEWS
    
    private func setupPhotoView() {
        self.addSubview(photoView)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
    }
    
    private func setupConstraints() {
        let topConstraint = self.photoView.topAnchor.constraint(equalTo: self.topAnchor)
        let leadingConstraint = self.photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailingConstraint = self.photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottomConstraint = self.photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
       
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, bottomConstraint, trailingConstraint
            ])
    }
}

// MARK: - EXTENSIONS

extension PhotosCollectionViewCell: Setupable { // MODEL

    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        self.photoView.image = UIImage(named: viewModel.image)
    }
}

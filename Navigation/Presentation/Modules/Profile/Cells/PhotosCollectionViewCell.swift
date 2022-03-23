//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Maksim Maiorov on 01.03.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel: ViewModelProtocol { // МОДЕЛЬ
        var image: String
    }
    
    let photoView: UIImageView = {  // ФОТО
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupPhotoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoView() { // устанавливаем интерфейс
        self.addSubview(photoView)
        setupConstraints()
    }
    
    override func prepareForReuse() { // обнуление информации в ячейках
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

extension PhotosCollectionViewCell: Setupable { // МОДЕЛЬ
    
    func setup(with viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModel else { return }
        self.photoView.image = UIImage(named: viewModel.image)
    }
}

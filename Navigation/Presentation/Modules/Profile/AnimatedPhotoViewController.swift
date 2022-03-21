//
//  AnimatedPhotoViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 17.03.2022.
//

import UIKit

class AnimatedPhotoViewController: UIViewController {
    
    // MARK: Properties
    struct ViewModel: ViewModelProtocol {
        var image: String // имя картинки из каталога Assets.xcassets
    }
   
//    private var image:
    lazy var largeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    private var widthLargeImage: NSLayoutConstraint? // размеры аватара
    private var heightLargeImage: NSLayoutConstraint?
    private var positionXLargeImage: NSLayoutConstraint? // позиция аватвра
    private var positionYLargeImage: NSLayoutConstraint?
    
    private lazy var transitionButton: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()
        let image = UIImage(named: "cancel")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.alpha = 0.0
        
        return button
    }()
  
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.0)
        setupSubView()
        
        
        self.view.layoutIfNeeded()
        moveIn()
    }
    
    // MARK: Setup SubView
    private func setupSubView() {  // Создаем констрейты
        self.view.addSubview(largeImage)
        self.view.addSubview(transitionButton)
        
        self.widthLargeImage = self.largeImage.widthAnchor.constraint(equalToConstant: 138)
        self.heightLargeImage = self.largeImage.heightAnchor.constraint(equalToConstant: 138)
        self.positionXLargeImage = self.largeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.positionYLargeImage = self.largeImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let buttonTopConstrain = self.transitionButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
        let buttonTrailingConstraint = self.transitionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        let buttonHeightConstraint = self.transitionButton.heightAnchor.constraint(equalToConstant: 40)
        let buttonWidthConstraint = self.transitionButton.widthAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            self.widthLargeImage, self.heightLargeImage, self.positionXLargeImage, self.positionYLargeImage,
            buttonTopConstrain, buttonTrailingConstraint, buttonHeightConstraint, buttonWidthConstraint
        ].compactMap( {$0} ))
    }
    
    private func moveIn() {
        NSLayoutConstraint.deactivate([
           self.positionXLargeImage, self.positionYLargeImage, self.widthLargeImage, self.heightLargeImage
        ].compactMap( {$0} ))
        
        self.widthLargeImage = self.largeImage.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        self.heightLargeImage = self.largeImage.heightAnchor.constraint(equalTo: self.view.widthAnchor)
        self.positionXLargeImage = self.largeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.positionYLargeImage = self.largeImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        UIView.animate(withDuration: 1, animations: { // замедляем открытие/закрытие текстового поля
            NSLayoutConstraint.activate([
               self.positionXLargeImage, self.positionYLargeImage, self.widthLargeImage, self.heightLargeImage
            ].compactMap( {$0} ))
            self.largeImage.layer.cornerRadius = 0.0
            self.view.backgroundColor = .black.withAlphaComponent(0.8)
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.25) {
            self.transitionButton.alpha = 1
            }
        }
    }
    
    func moveOut() {
        NSLayoutConstraint.deactivate([
            self.positionXLargeImage, self.positionYLargeImage, self.widthLargeImage, self.heightLargeImage
        ].compactMap( {$0} ))
        
        self.widthLargeImage = self.largeImage.widthAnchor.constraint(equalToConstant: 138)
        self.heightLargeImage = self.largeImage.heightAnchor.constraint(equalToConstant: 138)
        self.positionXLargeImage = self.largeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.positionYLargeImage = self.largeImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        UIView.animate(withDuration: 1, animations: {
            NSLayoutConstraint.activate([
                self.positionXLargeImage, self.positionYLargeImage, self.widthLargeImage, self.heightLargeImage
            ].compactMap( {$0} ))
            self.largeImage.layer.cornerRadius = 70.0
            self.view.backgroundColor = .black.withAlphaComponent(0.8)
            self.transitionButton.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
      @objc private func clickButton() {  // возвращение к родительскому ViewController
          moveOut()
      }
}

extension AnimatedPhotoViewController: Setupable { // устанавливаем модель

    func setup(with viewModel: ViewModelProtocol) { // наполнение ячейки
        guard let viewModel = viewModel as? ViewModel else { return }
        self.largeImage.image = UIImage(named: viewModel.image)
    }
}

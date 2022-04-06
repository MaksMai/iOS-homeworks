//
//  PostViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class PostViewController: UIViewController {
   
    // MARK: - PROPERTIES
    
    var titlePost: String = "Anonymous" // Создаем переменную для смены заголовка
    
    private lazy var button: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(clickButton)) // Создаем кнопку

    // MARK: - LIFECYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray // Задаем базовый цвет
        self.navigationItem.title = titlePost // Выставляем title полученного поста в качестве заголовка контроллера.
        self.navigationItem.rightBarButtonItem = button  // Добавляем кнопку
    }
  
    // MARK: - SETUP SUBVIEWS
    
    @objc private func clickButton() {  // Действие кнопки
        let infoViewController = InfoViewController()   // Создаем InfoViewController
        infoViewController.modalPresentationStyle = .automatic  //  должен показаться модально
        present(infoViewController, animated: true, completion: nil) // Вызываем InfoViewController
    }
}

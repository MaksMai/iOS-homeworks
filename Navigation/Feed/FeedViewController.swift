//
//  FeedViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class FeedViewController: UIViewController {
    // Создаем объект типа Post в FeedViewController
    var post = Post(title: "Мой пост")
    
    // Создаем кнопку перехода
    private lazy var button: UIButton = {
        // Кнопка
        let button = UIButton(frame: CGRect(x: 110, y: 110, width: 200, height: 50))
        // Цвет кнопки
        button.backgroundColor = .blue
        // Скруглим
        button.layer.cornerRadius = 12
        // Текст кнопки
        button.setTitle("Перейти на пост", for: .normal)
        // Цвет текста
        button.setTitleColor(.lightGray, for: .normal)
        // Делаем жирным
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        // Добавляем Action
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // Отключаем AutoresizingMask
        button.translatesAutoresizingMaskIntoConstraints = false
        // Возвращаем кнопку
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем базовый цвет
        view.backgroundColor = .lightGray
        // Делаем жирный заголовок
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Переименовываем обратный переход из PostViewController
        self.navigationItem.backButtonTitle = "Назад"
        // Добавляем кнопку
        self.view.addSubview(self.button)
        // Создаем констрейты к кнопке
        self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true // низ
        self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true // левый край
        self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true // левый край
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true // высота
    }
    
    // Делаем переход на PostViewController
    @objc private func buttonAction() {
        // Создаем PostViewController
        let postViewController = PostViewController()
        // Передаем объект post в PostViewController
        postViewController.titlePost = post.title
        // Вызываем PostViewController
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

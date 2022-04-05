//
//  FeedViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class FeedViewController: UIViewController {
   
    // MARK: - PROPERTIES
    
    var post = Post(title: "Мой пост")  // Создаем объект типа Post в FeedViewController
    
    private lazy var buttonStackView: UIStackView = {  // Создаем стек для кнопок
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .vertical // вертикальный стек
        stackView.distribution = .fillEqually // содержимое на всю высоту стека
        stackView.spacing = 10

        return stackView
    }()
    
    private lazy var firstButton: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()   // Кнопка
        button.backgroundColor = .systemBlue  // Цвет кнопки
        button.layer.cornerRadius = 12  // Скруглим
        button.setTitle("Перейти на пост", for: .normal)  // Текст кнопки
        button.setTitleColor(.lightGray, for: .normal)  // Цвет текста
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)   // Делаем жирным
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)   // Добавляем Action
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
     
        return button   // Возвращаем кнопку
    }()
    
    private lazy var secondButton: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()   // Кнопка
        button.backgroundColor = .systemRed  // Цвет кнопки
        button.layer.cornerRadius = 12  // Скруглим
        button.setTitle("Перейти на пост", for: .normal)  // Текст кнопки
        button.setTitleColor(.lightGray, for: .normal)  // Цвет текста
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)   // Делаем жирным
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)   // Добавляем Action
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
     
        return button   // Возвращаем кнопку
    }()
    
    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setButtonStackView() // отображаем стак с кнопками
    }
    
    // MARK: - SETUP SUBVIEWS
    
    private func setupNavigationBar() { // Устанавлинаваем название заголовка
        view.backgroundColor = .lightGray  // Задаем базовый цвет
        self.navigationItem.backButtonTitle = "Назад"   // Переименовываем обратный переход
        self.navigationItem.title = "Лента"
       }
    
    func setButtonStackView() {  // Создаем констрейты к кнопке
        self.view.addSubview(self.buttonStackView)  // Добавляем стак
        self.buttonStackView.addArrangedSubview(firstButton)
        self.buttonStackView.addArrangedSubview(secondButton)
        
        NSLayoutConstraint.activate([
            self.buttonStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.firstButton.heightAnchor.constraint(equalToConstant: 50),
            self.secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func buttonAction() { // Делаем переход на PostViewController
        let viewController = PostViewController()  // Создаем PostViewController
        viewController.titlePost = post.title  // Передаем объект post в PostViewController
        self.navigationController?.pushViewController(viewController, animated: true)    // Вызываем PostViewController
    }
}

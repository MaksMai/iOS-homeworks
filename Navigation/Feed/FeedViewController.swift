//
//  FeedViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class FeedViewController: UIViewController {
   
    var post = Post(title: "Мой пост")  // Создаем объект типа Post в FeedViewController
    
    private lazy var button: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()   // Кнопка
        button.backgroundColor = .blue  // Цвет кнопки
        button.layer.cornerRadius = 12  // Скруглим
        button.setTitle("Перейти на пост", for: .normal)  // Текст кнопки
        button.setTitleColor(.lightGray, for: .normal)  // Цвет текста
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)   // Делаем жирным
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)   // Добавляем Action
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
     
        return button   // Возвращаем кнопку
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray  // Задаем базовый цвет
        // Делаем жирный заголовок
        // self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backButtonTitle = "Назад"   // Переименовываем обратный переход
        self.view.addSubview(self.button)  // Добавляем кнопку
        setConstrains() // Активируем констрейны
    }
    
    func setConstrains() {  // Создаем констрейты к кнопке
        let buttonBottomAnchor = self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16) // низ
        let buttonLeadingAnchor = self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20) // левый край
        let buttonTrailingAnchor = self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20) // левый край
        let buttonHeightAnchor = self.button.heightAnchor.constraint(equalToConstant: 50) // высота
        NSLayoutConstraint.activate([buttonBottomAnchor, buttonLeadingAnchor, buttonTrailingAnchor, buttonHeightAnchor].compactMap( {$0} )) // Активация констрейнов
    }
    
    @objc private func buttonAction() { // Делаем переход на PostViewController
        let postViewController = PostViewController()  // Создаем PostViewController
        postViewController.titlePost = post.title  // Передаем объект post в PostViewController
        self.navigationController?.pushViewController(postViewController, animated: true)    // Вызываем PostViewController
    }
}

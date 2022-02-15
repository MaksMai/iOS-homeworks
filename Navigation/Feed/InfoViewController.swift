//
//  InfoViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class InfoViewController: UIViewController {
    // Создаем Alert кнопку
    private lazy var button: UIButton = {
        // Кнопка
        let button = UIButton(frame: CGRect(x: 110, y: 110, width: 200, height: 50))
        // Цвет кнопки
        button.backgroundColor = .red
        // Скруглим
        button.layer.cornerRadius = 12
        // Текст кнопки
        button.setTitle("Показать алерт", for: .normal)
        // Цвет текста
        button.setTitleColor(.lightGray, for: .normal)
        // Делаем жирным
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        // Добавим иконку
        // button.setImage(UIImage(systemName: "doc.richtext"), for: .normal)
        // Добавляем Action
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // Отключаем AutoresizingMask
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем базовый цвет
        self.view.backgroundColor = .opaqueSeparator
        // Добавляем кнопку
        self.view.addSubview(self.button)
        // Создаем констрейты к кнопке
        self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true // низ
        self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true // левый край
        self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true // правый край
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true // высота
    }
    
    // Делаем переход на UIAlertController
    @objc private func buttonAction() {
        // Вызываем AlertController
        self.showAlert()
    }
    // Создаем кнопку.
    // При нажатии на неё должен показаться UIAlertController с заданным title, message и двумя UIAlertAction.
    // При нажатии на UIAlertAction в консоль должно выводиться сообщение.
    private func showAlert() {
        // Создаем AlertController
        let alertController = UIAlertController(title: "ВНИМАНИЕ", message: "Ты хочешь узнать правду?", preferredStyle: .alert)
        // Кнопка Да
        let yesButton = UIAlertAction(title: "Да", style: .default) { Action in
            print("Нажата кнопка Да")
        }
        // Кнопка Нет
        let noButton = UIAlertAction(title: "Нет", style: .cancel) { Action in
            print("Нажата кнопка Нет")
        }
        // Действие кнопок
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        // Выводим на экран
        present(alertController, animated: true, completion: nil)
    }
}


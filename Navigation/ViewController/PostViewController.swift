//
//  PostViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class PostViewController: UIViewController {
    // Сщздаем переменную для смены заголовка
    var titlePost: String = "Anonymous"
    // Создаем кнопку
    private lazy var button: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(clickButton))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем базовый цвет
        self.view.backgroundColor = .lightGray
        // Выставляем title полученного поста в качестве заголовка контроллера.
        self.navigationItem.title = titlePost
        // Добавляем кнопку
        self.navigationItem.rightBarButtonItem = button
      
    }
    // Действие кнопки
    @objc private func clickButton() {
        // Создаем InfoViewController
        let infoViewController = InfoViewController()
        // InfoViewController должен показаться модально
        infoViewController.modalPresentationStyle = .automatic
        // Вызываем InfoViewController
        present(infoViewController, animated: true, completion: nil)
    }
}

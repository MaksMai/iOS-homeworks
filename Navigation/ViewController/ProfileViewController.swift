//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем базовый цвет
        view.backgroundColor = .lightGray
        // Делаем жирный заголовок
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

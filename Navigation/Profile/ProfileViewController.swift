//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Создаем экземпляр класса ProfileHeaderView в классе ProfileViewController
    let profileHeaderView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем базовый цвет
        view.backgroundColor = .lightGray
        // Добавляем ProfileHeaderView в качестве subview
        view.addSubview(profileHeaderView)
    }
    
    internal override func viewWillLayoutSubviews() {
        // Задаем profileHeaderView frame, равный frame корневого view
        profileHeaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileHeaderView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
    }
}

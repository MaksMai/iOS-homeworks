//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // Создаем экземпляр класса ProfileHeaderView в классе ProfileViewController
    private lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView(frame: .zero) // создаем вью ProfileHeaderView
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        
        return view
    }()
    
    private var heightConstraint: NSLayoutConstraint? // делегируем управление высотой вью
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray // Задаем базовый цвет
        self.view.addSubview(self.profileHeaderView) // Добавляем ProfileHeaderView в качестве subview
        viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {  // Создаем констрейты к profileHeaderView
        let viewTopConstraint = self.profileHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor) // верх
        let viewLeadingConstraint = self.profileHeaderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor) // левый край
        let viewTrailingConstraint = self.profileHeaderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor) // левый край
        self.heightConstraint = self.profileHeaderView.heightAnchor.constraint(equalToConstant: 220) // высота
        NSLayoutConstraint.activate([
            viewTopConstraint, viewLeadingConstraint, viewTrailingConstraint, self.heightConstraint
        ].compactMap( {$0} )) // Активация констрейнов
    }
}

extension ProfileViewController: ProfileHeaderViewProtocol { // разширение разширения вью

    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) {
        self.heightConstraint?.constant = inputTextIsVisible ? 220 : 250

        UIView.animate(withDuration: 0.5, delay: 0.0) { // замедляем открытие/закрытие текстового поля
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}

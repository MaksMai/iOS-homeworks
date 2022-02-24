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
    
    private lazy var titleStackView: UIStackView = {  // Создаем стек для кнопок
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .vertical // вертикальный стек
        stackView.distribution = .fill // содержимое на всю высоту стека
        stackView.spacing = 10

        return stackView
    }()
    
    private lazy var titleTextField: UITextField = { // Устанавливаем текстовое поле
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоконстрейны
        textField.backgroundColor = .white // цвет поля
        textField.textColor = .black // Цвет надписи
        textField.font = UIFont.systemFont(ofSize: 15.0) // Шрифт и размеры
        textField.layer.borderWidth = 1.0  // делаем рамку-обводку
        textField.layer.borderColor = UIColor.black.cgColor// устанавливаем цвет рамке
        textField.layer.cornerRadius = 12.0  // делаем скругление
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0)) // Отступ слева
        textField.leftView = leftView // добавим отступ
        textField.leftViewMode = .always
        textField.clipsToBounds = true  // устанавливаем вид в границах рамки
        textField.placeholder = "Введите заголовок"  // плейсхолдер для красоты

        return textField
    }()
    
    private lazy var titleButton: UIButton = {  // Создаем кнопку перехода
        let button = UIButton()   // Кнопка
        button.backgroundColor = .blue  // Цвет кнопки
        button.layer.cornerRadius = 12  // Скруглим
        button.setTitle("Сменить заголовок", for: .normal)  // Текст кнопки
        button.setTitleColor(.lightGray, for: .normal)  // Цвет текста
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)   // Делаем жирным
        button.addTarget(self, action: #selector(titleButtonAction), for: .touchUpInside)   // Добавляем Action
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем AutoresizingMask
     
        return button   // Возвращаем кнопку
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view.addSubview(self.profileHeaderView) // Добавляем ProfileHeaderView в качестве subview
        setupView() // отображаем вьюху
        tapGesturt() // скрываем клавиатуру
        setTitleStackView()
    }
    
    private func setupNavigationBar() { // Устанавлинаваем название заголовка
           self.navigationItem.title = "Профиль"
       }
    
    private func setupView() {  // Создаем констрейты к profileHeaderView
        self.view.backgroundColor = .lightGray // Задаем базовый цвет
        
        let viewTopConstraint = self.profileHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor) // верх
        let viewLeadingConstraint = self.profileHeaderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor) // левый край
        let viewTrailingConstraint = self.profileHeaderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor) // левый край
        self.heightConstraint = self.profileHeaderView.heightAnchor.constraint(equalToConstant: 220) // высота
        NSLayoutConstraint.activate([
            viewTopConstraint, viewLeadingConstraint, viewTrailingConstraint, self.heightConstraint
        ].compactMap( {$0} )) // Активация констрейнов
    }
    
    func tapGesturt() { // метод скрытия клавиатуры при нажатии на экран
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setTitleStackView() {  // Создаем констрейты к стаку
        self.view.addSubview(self.titleStackView)  // Добавляем стак
        self.titleStackView.addArrangedSubview(titleTextField)
        self.titleStackView.addArrangedSubview(titleButton)
        
        let titleStackViewCenterY = self.titleStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor) // центр по Х
        let titleStackViewLeadingConstraint = self.titleStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16) // слева
        let titleStackViewTrailingConstraint = self.titleStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16) // справа

        
        let titleTextFieldHeightAnchor = self.titleTextField.heightAnchor.constraint(equalToConstant: 40) // высота
        let titleButtonHeightAnchor = self.titleButton.heightAnchor.constraint(equalToConstant: 50) // высота
        NSLayoutConstraint.activate([titleStackViewCenterY, titleStackViewLeadingConstraint,
                                     titleStackViewTrailingConstraint, titleTextFieldHeightAnchor,
                                     titleButtonHeightAnchor
                                    ]) // Активация констрейнов
    }
    
    @objc private func titleButtonAction() { // Делаем переход на PostViewController
        self.navigationItem.title = titleTextField.text!
        titleTextField.text = nil
    }
    
}

extension ProfileViewController: ProfileHeaderViewProtocol { // разширение разширения вью

    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) {
        self.heightConstraint?.constant = inputTextIsVisible ? 250 : 220

        UIView.animate(withDuration: 0.2, delay: 0.0) { // замедляем открытие/закрытие текстового поля
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}
    

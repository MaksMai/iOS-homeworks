//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 11.02.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var statusText: String? = nil // переменная для хранения текста статуса
    // Создаем аватар
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "myfoto.jpg")) // подгружаем картинку
        imageView.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        imageView.layer.borderWidth = 3.0 // делаем рамку-обводку
        imageView.layer.borderColor = UIColor.white.cgColor // устанавливаем цвет рамке
        imageView.layer.cornerRadius = 61.0 // делаем скругление - превращием квадрат в круг
        imageView.clipsToBounds = true // устанавливаем вид в границах рамки
        
        return imageView
    }()
    // Создаем стек для меток
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = NSLayoutConstraint.Axis.vertical // вертикальный стек
        stackView.distribution = UIStackView.Distribution.equalSpacing // содержимое на всю высоту стека
        
        return stackView
    }()
    // Устанавливаем метку имени
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel() // Создаем метку
        nameLabel.text  = "MaksMai" // Именуем метку
        nameLabel.textColor = .black // цвет текста
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18.0) // тольщина и размер текста
        
        return nameLabel
    }()
    // Устанавливаем метку статуса
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = nil
        statusLabel.textColor = .gray
        statusLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        return statusLabel
    }()
    // Устанавливаем текстовое поле
    private lazy var inputText: UITextField = {
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
        textField.placeholder = "Введите статус"  // плейсхолдер для красоты
        textField.addTarget(self, action: #selector(ProfileHeaderView.statusTextChanged(_:)), for: .editingChanged) // Добавьте обработку изменения введенного текста
        
        return textField
    }()
    // Создаем кнопку
    private lazy var statusButton: UIButton = {
        let statusButton = UIButton() // создаем кнопку
        statusButton.setTitle("Show status", for: .normal)  // Устанавливаем надпись
        statusButton.setTitleColor(.white, for: .normal) // Цвет надписи
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Шрифт и размеры
        statusButton.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        statusButton.backgroundColor = .blue  // задаем цвет кнопке
        statusButton.layer.cornerRadius = 4  // скругляем углы
        statusButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside) // Добавляем Action
        // устанавливаем тень кнопки
        statusButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        statusButton.layer.shadowRadius = 4.0
        statusButton.layer.shadowColor = UIColor.black.cgColor
        statusButton.layer.shadowOpacity = 0.7
        statusButton.layer.shouldRasterize = true
        
        return statusButton
    }()
    
    override init(frame: CGRect) { // Выводим обьекты во view
        super.init(frame: frame)
        createSubviews()
        setupConstraints()
    }
    // восстанавливаем интерфейс
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
        setupConstraints()
    }
    // добавляем обьекты ао вьюшку
    func createSubviews() {
        addSubview(avatar) // добавляем аватарку
        addSubview(inputText) // Добавляем текстовое поле
        addSubview(statusButton) // добавляем кнопку
        addSubview(stackView) // добавляем стак и метки в стак
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(statusLabel)
    }
    // Устанавливаем констрейны
    func setupConstraints() {
        // Констрейны аватар
        self.avatar.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 16).isActive = true // от верха
        self.avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true // слева
        self.avatar.heightAnchor.constraint(equalToConstant: 122).isActive = true // высота
        self.avatar.widthAnchor.constraint(equalToConstant: 122).isActive = true // ширина
        // Констрейны стека
        self.stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 27).isActive = true // от аватарки
        self.stackView.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 16).isActive = true // слева
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true // справа
        self.stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true // высота
        // Текстового поля
        self.inputText.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 8).isActive = true // от аватарки
        self.inputText.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 16).isActive = true // слева
        self.inputText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true // справа
        self.inputText.heightAnchor.constraint(equalToConstant: 40).isActive = true // высота
        // Констрейны кнопки
        self.statusButton.topAnchor.constraint(equalTo: self.inputText.bottomAnchor, constant: 16).isActive = true // от текстового поля
        self.statusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true // слева
        self.statusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true // справа
        self.statusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true // высота
    }
    
    // Вставляем текст
    @objc private func buttonAction() {
        statusText = inputText.text! // Меняем текст
        statusLabel.text = "\(statusText ?? "")"
    }
    // Выводим в консоль результат отслеживаемого изменеия
    @objc func statusTextChanged(_ textField: UITextField) {
        let status: String = textField.text ?? ""
        print("Новый статус = \(status)")
    }
}

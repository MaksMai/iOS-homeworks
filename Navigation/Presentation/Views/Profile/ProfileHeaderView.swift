//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 11.02.2022.
//

import UIKit

protocol ProfileHeaderViewProtocol: AnyObject { // расширение вью по нажатии кнопки - делегат
    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void)
}

class ProfileHeaderView: UIView, UITextFieldDelegate {
    
    var statusText: String? = nil // переменная для хранения текста статуса
  
    private lazy var avatar: UIImageView = {  // Создаем аватар
        let imageView = UIImageView(image: UIImage(named: "myfoto.jpg")) // подгружаем картинку
        imageView.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        imageView.layer.borderWidth = 3.0 // делаем рамку-обводку
        imageView.layer.borderColor = UIColor.white.cgColor // устанавливаем цвет рамке
        imageView.layer.cornerRadius = 70.0 // делаем скругление - превращием квадрат в круг
        imageView.clipsToBounds = true // устанавливаем вид в границах рамки

        return imageView
    }()

    private lazy var labelStackView: UIStackView = {  // Создаем стек для меток
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .vertical // вертикальный стек
        stackView.distribution = .fillEqually // содержимое на всю высоту стека
        stackView.spacing = 40

        return stackView
    }()

    private lazy var avatarStackView: UIStackView = {  // Создаем стек для меток
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .horizontal // горизонтальный стек
        stackView.spacing = 16

        return stackView
    }()

    private lazy var nameLabel: UILabel = {   // Устанавливаем метку имени
        let nameLabel = UILabel() // Создаем метку
        nameLabel.text  = "MaksMai" // Именуем метку
        nameLabel.textColor = .black // цвет текста
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18.0) // тольщина и размер текста

        return nameLabel
    }()

    private lazy var statusLabel: UILabel = {   // Устанавливаем метку статуса
        let statusLabel = UILabel()
        statusLabel.textColor = .gray
        statusLabel.font = UIFont.systemFont(ofSize: 14.0)

        return statusLabel
    }()
   
    private lazy var textField: UITextField = { // Устанавливаем текстовое поле
        let textField = UITextField()
        textField.isHidden = true // текстовое поле спрятано
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

        return textField
    }()
  
    private lazy var statusButton: UIButton = {  // Создаем кнопку
        let statusButton = UIButton() // создаем кнопку
        statusButton.setTitle("Show status", for: .normal)  // Устанавливаем надпись
        statusButton.setTitleColor(.white, for: .normal) // Цвет надписи
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Шрифт и размеры
        statusButton.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        statusButton.backgroundColor = .blue  // задаем цвет кнопке
        statusButton.layer.cornerRadius = 4  // скругляем углы
        statusButton.addTarget(self, action: #selector(buttonAction),
                               for: .touchUpInside) // Добавляем Action
        // устанавливаем тень кнопки
        statusButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        statusButton.layer.shadowRadius = 4.0
        statusButton.layer.shadowColor = UIColor.black.cgColor
        statusButton.layer.shadowOpacity = 0.7
        statusButton.layer.shouldRasterize = true
        
        return statusButton
    }()
    
    private var buttonTopConstrain: NSLayoutConstraint? // делегируем изменение верхнего констрейна кнопки
    
    weak var delegate: ProfileHeaderViewProtocol? // создаем делегата
    
    override init(frame: CGRect) { // Выводим обьекты во view
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) { // восстанавливаем интерфейс
        fatalError("init(coder:) yas not been")
    }
  
    func createSubviews() {  // добавляем обьекты ао вьюшку
        self.addSubview(avatarStackView) // добавляем стак и метки в горизонтальный стак
        self.addSubview(textField) // Добавляем текстовое поле
        self.addSubview(statusButton) // добавляем кнопку
        self.avatarStackView.addArrangedSubview(avatar) // добавляем в стак аватар
        self.avatarStackView.addArrangedSubview(labelStackView) // добавляем в стак стак
        self.labelStackView.addArrangedSubview(nameLabel) // добавляем в стак метку
        self.labelStackView.addArrangedSubview(statusLabel) // добавляем в стак метку

        setupConstraints()
        self.textField.delegate = self
    }
  
    func setupConstraints() {  // Устанавливаем констрейны
        // Горизонтальный стак
        let avatarStackViewTopConstraint = self.avatarStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16) // верх
        let avatarStackViewLeadingConstraint = self.avatarStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16) // слева
        let avatarStackViewTrailingConstraint = self.avatarStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16) // справа
        // Констрейны аватар
        let imageRatioConstraint = self.avatar.heightAnchor.constraint(equalTo: self.avatar.widthAnchor, multiplier: 1.0)

        //  Констрейны кнопки
        self.buttonTopConstrain = self.statusButton.topAnchor.constraint(equalTo: self.avatarStackView.bottomAnchor, constant: 16) // верх
        self.buttonTopConstrain?.priority = UILayoutPriority(rawValue: 999)
        let buttonLeadingConstraint = self.statusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16) // слева
        let buttonTrailingConstraint = self.statusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16) // справа
        let buttonHeightConstraint = self.statusButton.heightAnchor.constraint(equalToConstant: 50) // высота
        let buttonBottomConstraint = self.statusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            avatarStackViewTopConstraint, avatarStackViewLeadingConstraint,
            avatarStackViewTrailingConstraint, imageRatioConstraint, self.buttonTopConstrain,
            buttonLeadingConstraint, buttonTrailingConstraint, buttonHeightConstraint, buttonBottomConstraint
        ].compactMap( {$0} ))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // закрытие клавиатуры при нажатии на ВВОД
        self.endEditing(true)
        return false
    }
    
    
    @objc private func buttonAction() { // Вставляем текстовое поле
        
        let topConstrain = self.textField.topAnchor.constraint(equalTo: self.avatarStackView.bottomAnchor, constant: -10) // верх layoutMarginsGuide
        let leadingConstrain = self.textField.leadingAnchor.constraint(equalTo: self.labelStackView.leadingAnchor) // слева
        let trailingConstrain = self.textField.trailingAnchor.constraint(equalTo: self.avatarStackView.trailingAnchor) // справа
        let textHeight = self.textField.heightAnchor.constraint(equalToConstant: 40) // высота

        self.buttonTopConstrain = self.statusButton.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 16) // верх
        
        textField.becomeFirstResponder() // автовыброс клавиатуры
        
        if self.textField.isHidden { // показываем текстовое поле
            self.addSubview(self.textField)
            textField.text = nil
            
            statusButton.setTitle("Set status", for: .normal)  // Устанавливаем надпись
            self.buttonTopConstrain?.isActive = false
            NSLayoutConstraint.activate([topConstrain, leadingConstrain, trailingConstrain, textHeight, buttonTopConstrain].compactMap( {$0} ))
            
        } else {
            statusText = textField.text! // Меняем текст
            statusLabel.text = "\(statusText ?? "")"
            statusButton.setTitle("Show status", for: .normal)
            
            self.textField.removeFromSuperview()
            NSLayoutConstraint.deactivate([topConstrain, leadingConstrain, trailingConstrain, textHeight].compactMap( {$0} ))
        }
        
        self.delegate?.buttonAction(inputTextIsVisible: self.textField.isHidden) { [weak self] in
            self?.textField.isHidden.toggle() // меняем высоту
        }
    }
   
    @objc func statusTextChanged(_ textField: UITextField) {  // Выводим в консоль результат отслеживаемого изменеия
        let status: String = textField.text ?? ""
        print("Новый статус = \(status)")
    }
}


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

class ProfileHeaderView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var statusText: String? = nil // переменная для хранения текста статуса
  
     lazy var avatarImageView: UIImageView = {  // Создаем аватар
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

    private lazy var firstStackView: UIStackView = {  // Создаем стек для меток
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .horizontal // горизонтальный стек
        stackView.spacing = 16

        return stackView
    }()

    private lazy var fullNameLabel: UILabel = {   // Устанавливаем метку имени
        let label = UILabel() // Создаем метку
        label.text  = "MaksMai" // Именуем метку
        label.textColor = .black // цвет текста
        label.font = UIFont.boldSystemFont(ofSize: 18.0) // тольщина и размер текста

        return label
    }()

    private lazy var statusLabel: UILabel = {   // Устанавливаем метку статуса
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0)

        return label
    }()
   
    private lazy var statusTextField: UITextField = { // Устанавливаем текстовое поле
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
  
    private lazy var setStatusButton: UIButton = {  // Создаем кнопку
        let button = UIButton() // создаем кнопку
        button.setTitle("Show status", for: .normal)  // Устанавливаем надпись
        button.setTitleColor(.white, for: .normal) // Цвет надписи
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Шрифт и размеры
        button.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        button.backgroundColor = .blue  // задаем цвет кнопке
        button.layer.cornerRadius = 4  // скругляем углы
        button.addTarget(self, action: #selector(buttonAction),
                               for: .touchUpInside) // Добавляем Action
        // устанавливаем тень кнопки
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shouldRasterize = true
        button.layer.shadowPath =  UIBezierPath(rect: button.bounds).cgPath
        
        return button
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
        self.addSubview(firstStackView) // добавляем стак и метки в горизонтальный стак
        self.addSubview(statusTextField) // Добавляем текстовое поле
        self.addSubview(setStatusButton) // добавляем кнопку
        self.firstStackView.addArrangedSubview(avatarImageView) // добавляем в стак аватар
        self.firstStackView.addArrangedSubview(labelStackView) // добавляем в стак стак
        self.labelStackView.addArrangedSubview(fullNameLabel) // добавляем в стак метку
        self.labelStackView.addArrangedSubview(statusLabel) // добавляем в стак метку
        self.statusTextField.delegate = self
        setupConstraints()
    }
  
    func setupConstraints() {  // Устанавливаем констрейны
        // Горизонтальный стак
        let firstStackViewTopConstraint = self.firstStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16) // верх
        let firstStackViewLeadingConstraint = self.firstStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16) // слева
        let firstStackViewTrailingConstraint = self.firstStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16) // справа
       
        let avatarImageViewRatioConstraint = self.avatarImageView.heightAnchor.constraint(equalTo: self.avatarImageView.widthAnchor, multiplier: 1.0) // аватвр 1 к 1 в стаке

        //  Констрейны кнопки
        self.buttonTopConstrain = self.setStatusButton.topAnchor.constraint(equalTo: self.firstStackView.bottomAnchor, constant: 16) // верх
        self.buttonTopConstrain?.priority = UILayoutPriority(rawValue: 999)
        let buttonLeadingConstraint = self.setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16) // слева
        let buttonTrailingConstraint = self.setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16) // справа
        let buttonHeightConstraint = self.setStatusButton.heightAnchor.constraint(equalToConstant: 50) // высота
        let buttonBottomConstraint = self.setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            firstStackViewTopConstraint, firstStackViewLeadingConstraint,
            firstStackViewTrailingConstraint, avatarImageViewRatioConstraint,
            self.buttonTopConstrain, buttonLeadingConstraint, buttonTrailingConstraint,
            buttonHeightConstraint, buttonBottomConstraint
        ].compactMap( {$0} ))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // закрытие клавиатуры при нажатии на ВВОД
        self.endEditing(true)
        return false
    }
    
    @objc func buttonAction() { // Вставляем текстовое поле
        
        let topConstrain = self.statusTextField.topAnchor.constraint(equalTo: self.firstStackView.bottomAnchor, constant: -10) // верх layoutMarginsGuide
        let leadingConstrain = self.statusTextField.leadingAnchor.constraint(equalTo: self.labelStackView.leadingAnchor) // слева
        let trailingConstrain = self.statusTextField.trailingAnchor.constraint(equalTo: self.firstStackView.trailingAnchor) // справа
        let textHeight = self.statusTextField.heightAnchor.constraint(equalToConstant: 40) // высота

        self.buttonTopConstrain = self.setStatusButton.topAnchor.constraint(equalTo: self.statusTextField.bottomAnchor, constant: 16) // верх
        
        if self.statusTextField.isHidden { // показываем текстовое поле
            self.addSubview(self.statusTextField)
            statusTextField.text = nil
            
            setStatusButton.setTitle("Set status", for: .normal)  // Устанавливаем надпись
            self.buttonTopConstrain?.isActive = false
            NSLayoutConstraint.activate([topConstrain, leadingConstrain, trailingConstrain, textHeight, buttonTopConstrain].compactMap( {$0} ))
            
            statusTextField.becomeFirstResponder()
            
        } else {
            statusText = statusTextField.text! // Меняем текст
            statusLabel.text = "\(statusText ?? "")"
            setStatusButton.setTitle("Show status", for: .normal)
            
            self.statusTextField.removeFromSuperview()
            NSLayoutConstraint.deactivate([
                topConstrain, leadingConstrain, trailingConstrain, textHeight
            ].compactMap( {$0} ))
        }
        
        self.delegate?.buttonAction(inputTextIsVisible: self.statusTextField.isHidden) { [weak self] in
            self?.statusTextField.isHidden.toggle() // меняем высоту
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {  // Выводим в консоль результат отслеживаемого изменеия
        let status: String = textField.text ?? ""
        print("Новый статус = \(status)")
    }
}


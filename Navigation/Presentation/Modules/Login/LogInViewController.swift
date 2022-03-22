//
//  LogInViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 22.02.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    let user = User(login: "test@test.ru", password: "1Q2w3e4r") // ЛОГИН и ПАРОЛЬ
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var logoView: UIImageView = { // ЛОГОТИП
        let logoView = UIImageView(image: UIImage(named: "logo.jpg"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        return logoView
    }()
    
    private lazy var initStackView: UIStackView = {  // стек инициализации
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = -0.5
        
        return stackView
    }()
    
    private lazy var loginTextField: UITextField = { // ЛОГИН
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16.0)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.placeholder = "E-mail"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {  // ПАРОЛЬ
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16.0)
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.placeholder = "Password"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var initButton: UIButton = {  // КНОПКА
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Log in", for: .normal)
        let image = UIImage(named: "blue_pixel")
        button.setBackgroundImage(image, for: .normal)
        if button.isSelected { // изменение прозрачности прри нажатии на кнопку
            button.alpha = 0.8
        } else if button.isHighlighted {
            button.alpha = 0.8
        } else {
            button.alpha = 1.0
        }
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var errorLabel: UILabel = { // ОШИБКА
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - LIFECIRCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        tapGesturt()
        registerNotification()
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - SETUP SUBVIEW
    
    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.logoView)
        self.contentView.addSubview(self.initStackView)
        self.initStackView.addArrangedSubview(textStackView)
        self.textStackView.addArrangedSubview(loginTextField)
        self.textStackView.addArrangedSubview(passwordTextField)
        self.initStackView.addArrangedSubview(initButton)
        self.view.addSubview(errorLabel)
    }
    
    func setupConstraints() { // Создаем констрейты к стаку
        let scrollViewTopConstraint = self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let scrollViewRightConstraint = self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        let scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let scrollViewLeftConstraint = self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let contentViewCenterXConstraint = self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)
        let contentViewWidth = self.contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        let contentViewTopConstraint = self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor)
        let contentViewBottomAnchor = self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        let logoViewCenterX = self.logoView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        let logoViewTopConstraint = self.logoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 120)
        let logoViewWidthAnchor = self.logoView.widthAnchor.constraint(equalToConstant: 100)
        let logoViewHeightAnchor = self.logoView.heightAnchor.constraint(equalToConstant: 100)
        let initStackViewTopConstraint = self.initStackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 120)
        let initStackViewLeadingConstraint = self.initStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let initStackViewTrailingConstraint = self.initStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let initStackViewBottomAnchor = self.initStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        let loginTextFieldHeightAnchor = self.loginTextField.heightAnchor.constraint(equalToConstant: 50)
        let passwordTextFieldHeightAnchor = self.passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        let initButtonHeightAnchor = self.initButton.heightAnchor.constraint(equalToConstant: 50)
        let errorLabelTopConstraint = self.errorLabel.topAnchor.constraint(equalTo: self.initStackView.bottomAnchor, constant: 16)
        let errorLabelRightConstraint = self.errorLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16)
        let errorLabelLeftConstraint = self.errorLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            scrollViewTopConstraint, scrollViewRightConstraint, scrollViewBottomConstraint,
            scrollViewLeftConstraint, contentViewTopConstraint, contentViewBottomAnchor,
            contentViewWidth, contentViewCenterXConstraint, logoViewCenterX, logoViewTopConstraint,
            logoViewWidthAnchor, logoViewHeightAnchor, initStackViewTopConstraint,
            initStackViewLeadingConstraint, initStackViewTrailingConstraint, loginTextFieldHeightAnchor,
            passwordTextFieldHeightAnchor, initButtonHeightAnchor, initStackViewBottomAnchor,
            errorLabelTopConstraint, errorLabelRightConstraint, errorLabelLeftConstraint
        ])
    }
    
    @objc private func buttonAction() {  // BUTTON ACTION
        if isEmpty(textField: loginTextField),
           validationEmail(textField: loginTextField),
           isEmpty(textField: passwordTextField),
           validationPassword(textField: passwordTextField) {
            let controller = TabBarController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func checkCount(inputString: UITextField, givenString: String) {
        guard inputString.text!.count < givenString.count - 1 ||
                inputString.text!.count > givenString.count - 1 else {
            errorLabel.text = ""
            
            return
        }
        errorLabel.textColor = .red
        errorLabel.text = "\(String(describing: inputString.placeholder!)) содержит \(givenString.count) символов"
    }
}

    // MARK: - EXTENSIONS

extension LogInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // ПРОВЕРКА КОЛИЧЕСВА ВВЕДЕННЫХ СИМВОЛОВ
        let text = (textField.text ?? "") + string
        let result: String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        if textField == loginTextField {
            checkCount(inputString: loginTextField, givenString: user.login)
        } else {
            checkCount(inputString: passwordTextField, givenString: user.password)
        }
        textField.text = result
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // ПЕРЕКЛЮЧЕНИЕ МЕЖДУ TEXTFIELD
        if textField == loginTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginTextField.becomeFirstResponder()
        }
        
        return true
    }
}

extension LogInViewController {
    
    // LOGIN AND PASSWORD VERIFICATION
    private func isEmpty(textField: UITextField) -> Bool { // ПОТРЯХИВАНИЕ ПУСТОГО TEXTFIELD
        guard textField.text != "" else {
            textField.shake()
            
            return false
        }
        
        return true
    }
    
    private func validationEmail(textField: UITextField) -> Bool { // ПРОВЕРКА ЛОГИНА
        guard textField.text!.isValidEmail, textField.text == user.login else {
            openAlert(title: "ОШИБКА",
                      message: "Некорректный ввод адреса электронной почты",
                      alertStyle: .alert, actionTitles: ["Повторить"],
                      actionStyles: [.default],
                      actions: [{ _ in
                print("ОШИБКА")
            }])
            
            return false
        }
        
        return true
    }
    
    private func validationPassword(textField: UITextField) -> Bool { // ПРОВЕРКА ПАРОЛЯ
        guard textField.text == user.password else {
            openAlert(title: "ОШИБКА",
                      message: "Некорректный ввод пароля",
                      alertStyle: .alert, actionTitles: ["Повторить"],
                      actionStyles: [.default],
                      actions: [{ _ in
                print("ОШИБКА")
            }])
            
            return false
        }
        
        return true
    }
    
    // KEYBOARD
    func tapGesturt() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LogInViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LogInViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        // I-й способ - подъем на высоту клавиатуры по правилам
        // if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        //    let keyboardRectangle = keyboardFrame.cgRectValue
        //    let keyboardHeight = keyboardRectangle.height
        //    let contentOffset: CGPoint = notification.name ==
        //    UIResponder.keyboardWillHideNotification
        //    ? .zero
        //    : CGPoint(x: 0, y: keyboardHeight)
        //    scrollView.contentOffset = contentOffset
        //}
        
        // II-й способ - подъем "топором"на высоту кнопки
        scrollView.contentOffset = CGPoint(x: 0, y: 70)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

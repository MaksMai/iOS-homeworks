//
//  LogInViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 22.02.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    let user = User(login: "t@t.ru", password: "1234") // ЛОГИН и ПАРОЛЬ
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var logoView: UIImageView = { // ЛОГОТИП
        let logoView = UIImageView(image: UIImage(named: "logo.jpg"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        return logoView
    }()
    
    private lazy var loginTextField: UITextField = { // ЛОГИН
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.placeholder = "E-mail"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = { // ПАРОЛЬ
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.placeholder = "Password"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var initButton: UIButton = {  // КНОПКА
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Log in", for: .normal)
        let image = UIImage(named: "blue_pixel")
        button.setBackgroundImage(image, for: .normal)
        if button.isSelected {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - SETUP SUBVIEW
    
    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoView)
        self.scrollView.addSubview(loginTextField)
        self.scrollView.addSubview(passwordTextField)
        self.scrollView.addSubview(initButton)
        self.view.addSubview(errorLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.logoView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoView.topAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: -193),
            self.logoView.heightAnchor.constraint(equalToConstant: 100),
            self.logoView.widthAnchor.constraint(equalToConstant: 100),
            
            self.loginTextField.bottomAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 120),
            self.loginTextField.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.passwordTextField.topAnchor.constraint(equalTo: self.loginTextField.bottomAnchor, constant: -1),
            self.passwordTextField.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.initButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 16),
            self.initButton.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.initButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.errorLabel.bottomAnchor.constraint(equalTo: self.loginTextField.topAnchor, constant: -16),
            self.errorLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.errorLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        ])
    }
    
    @objc private func buttonAction() {  // BUTTON ACTION
        if isEmpty(textField: loginTextField), validationEmail(textField: loginTextField),
           isEmpty(textField: passwordTextField), validationPassword(textField: passwordTextField) {
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

extension LogInViewController { // LOGIN AND PASSWORD VERIFICATION
    
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
    
    @objc private func keyboardWillShow(_ notification: Notification) { // ПОДЪЕМ
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let initButtonBottomY = self.initButton.frame.origin.y + initButton.frame.height
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            let contentOffset = keyboardOriginY < initButtonBottomY ? initButtonBottomY - keyboardOriginY + 50 : 0
            
            self.scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) { // ОПУСК
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

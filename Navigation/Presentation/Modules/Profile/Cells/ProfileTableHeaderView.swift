//
//  ProfileTableHeaderView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 22.03.2022.
//

import UIKit

// MARK: - PROTOCOLS

protocol ProfileTableHeaderViewProtocol: AnyObject {
    func buttonAction() // TEXTFIELD ISHIDDEN
    
    func delegateActionAnimatedAvatar(cell: ProfileTableHeaderView) // ANIMATED AVATAR
}

class ProfileTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - PROPERTIES
    
    private var statusText: String? // СТАТУС TEXTLABEL
    
    private lazy var mainStackView: UIStackView = {  // СТЭК ТЕКСТОВЫХ МЕТОК
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    lazy var avatarImageView: UIImageView = {  // АВАТАРКА
        let imageView = UIImageView(image: UIImage(named: "myfoto.jpg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 70.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {  // СТЭК ТЕКСТОВЫХ МЕТОК И КНОПКИ
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        
        return stackView
    }()
    
    private lazy var fullNameLabel: UILabel = {   // ТЕКСТОВАЯ МЕТКА ИМЕНИ
        let label = UILabel()
        label.text  = "MaksMai"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {   // ТЕКСТОВАЯ МЕТКА СТАТУСА
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        return label
    }()
    
    private lazy var statusTextField: UITextField = { // ТЕКСТОВЩЕ ПОЛЕ СТАТУСА
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15.0)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12.0
        textField.placeholder = "Введите статус"
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var setStatusButton: UIButton = {  // КНОПКА
        let button = UIButton()
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(buttonAction),
                         for: .touchUpInside)
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shouldRasterize = true
        button.layer.shadowPath =  UIBezierPath(rect: button.bounds).cgPath
        
        return button
    }()
    
    weak var delegate: ProfileTableHeaderViewProtocol? // ДЕЛЕГАТ НАЖАТИЯ
    
    private var tapGestureRecognizer = UITapGestureRecognizer() // НАЖАТИЕ НА АВАТАР
    
    // MARK: - LIFECYCLE METHODS
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP SUBVIEW
    
    func createSubviews() {
        self.addSubview(self.mainStackView)
        self.mainStackView.addArrangedSubview(self.avatarImageView)
        self.mainStackView.addArrangedSubview(self.labelStackView)
        self.labelStackView.addArrangedSubview(self.fullNameLabel)
        self.labelStackView.addArrangedSubview(self.statusLabel)
        self.addSubview(self.statusTextField)
        self.addSubview(self.setStatusButton)
        self.setupConstraints()
        self.setupTapGesture()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 138),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 138),
            
            self.statusTextField.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: -10),
            self.statusTextField.leadingAnchor.constraint(equalTo: self.labelStackView.leadingAnchor),
            self.statusTextField.trailingAnchor.constraint(equalTo: self.labelStackView.trailingAnchor),
            self.statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            self.setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            self.setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.setStatusButton.topAnchor.constraint(equalTo: self.statusTextField.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func buttonAction() { // ДЕЙСТВИЕ КНОПКИ
        guard statusTextField.text != "" else {
            statusTextField.shake()
            return
        }
        statusText = self.statusTextField.text!
        statusLabel.text = "\(statusText ?? "")"
        self.statusTextField.text = nil
    }
}

// MARK: - EXTENSIONS

extension ProfileTableHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // СПРЯТАТЬ КЛАВИАТУРУ ПО RETURN
        self.endEditing(true)
        return false
    }
}

extension ProfileTableHeaderView: UIGestureRecognizerDelegate { // ANIMATED AVATAR
    
    private func setupTapGesture() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleTapGesture(_:)))
        self.avatarImageView.addGestureRecognizer(self.tapGestureRecognizer)
        self.avatarImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.tapGestureRecognizer === gestureRecognizer else { return }
        delegate?.delegateActionAnimatedAvatar(cell: self)
    }
}

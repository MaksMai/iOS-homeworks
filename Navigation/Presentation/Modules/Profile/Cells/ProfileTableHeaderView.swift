//
//  ProfileTableHeaderView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 22.03.2022.
//

import UIKit

    // MARK: - PROTOCOLS

protocol ProfileTableHeaderViewProtocol: AnyObject {
    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) // TEXTFIELD ISHIDDEN
    
    func delegateAction(cell: ProfileTableHeaderView) // ПРИКОСНОВЕНИЕ К АВАТАР
}

class ProfileTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - PROPERTIES
    
    var statusText: String? // переменная для хранения текста статуса
    
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
    
    private lazy var firstStackView: UIStackView = {  // СТЭК ТЕКСТОВЫХ МЕТОК
        let stackView = UIStackView() // создаем стек
        stackView.translatesAutoresizingMaskIntoConstraints = false // отключаем констрейны
        stackView.axis = .horizontal // горизонтальный стек
        stackView.spacing = 16
        
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
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15.0)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12.0  // делаем скругление
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
        button.setTitle("Show status", for: .normal)
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
    
    private var buttonTopConstrain: NSLayoutConstraint?
    
    weak var delegate: ProfileTableHeaderViewProtocol? // ДЕЛЕГАТ НАЖАТИЯ
    
    private var tapGestureRecognizer = UITapGestureRecognizer() // НАЖАТИЕ НА АВАТАР
    
    // MARK: - LIFECYCLE METHODS
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP SUBVIEW
    
    func createSubviews() {
        self.addSubview(firstStackView)
        self.addSubview(statusTextField)
        self.addSubview(setStatusButton)
        self.firstStackView.addArrangedSubview(avatarImageView)
        self.firstStackView.addArrangedSubview(labelStackView)
        self.labelStackView.addArrangedSubview(fullNameLabel)
        self.labelStackView.addArrangedSubview(statusLabel)
        setupConstraints()
        setupTapGesture()
    }
    
    func setupConstraints() {
        let firstStackViewTopConstraint = self.firstStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        let firstStackViewLeadingConstraint = self.firstStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        let firstStackViewTrailingConstraint = self.firstStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        let avatarImageViewRatioConstraint = self.avatarImageView.heightAnchor.constraint(equalTo: self.avatarImageView.widthAnchor, multiplier: 1.0)
        self.buttonTopConstrain = self.setStatusButton.topAnchor.constraint(equalTo: self.firstStackView.bottomAnchor, constant: 16)
        self.buttonTopConstrain?.priority = UILayoutPriority(rawValue: 999)
        let buttonLeadingConstraint = self.setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        let buttonTrailingConstraint = self.setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        let buttonHeightConstraint = self.setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        let buttonBottomConstraint = self.setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            firstStackViewTopConstraint, firstStackViewLeadingConstraint,
            firstStackViewTrailingConstraint, avatarImageViewRatioConstraint,
            self.buttonTopConstrain, buttonLeadingConstraint, buttonTrailingConstraint,
            buttonHeightConstraint, buttonBottomConstraint
        ].compactMap( {$0} ))
    }
    
    @objc func buttonAction() { // ДЕЙСТВИЕ КНОПКИ
        let topConstrain = self.statusTextField.topAnchor.constraint(equalTo: self.firstStackView.bottomAnchor, constant: -10)
        let leadingConstrain = self.statusTextField.leadingAnchor.constraint(equalTo: self.labelStackView.leadingAnchor)
        let trailingConstrain = self.statusTextField.trailingAnchor.constraint(equalTo: self.firstStackView.trailingAnchor)
        let textHeight = self.statusTextField.heightAnchor.constraint(equalToConstant: 40)
        self.buttonTopConstrain = self.setStatusButton.topAnchor.constraint(equalTo: self.statusTextField.bottomAnchor, constant: 16)
        
        if self.statusTextField.isHidden {
            self.addSubview(self.statusTextField)
            statusTextField.text = nil
            setStatusButton.setTitle("Set status", for: .normal)
            self.buttonTopConstrain?.isActive = false
            NSLayoutConstraint.activate(
                [topConstrain, leadingConstrain, trailingConstrain,
                 textHeight, buttonTopConstrain]
                    .compactMap( {$0} ))
            statusTextField.becomeFirstResponder()
        } else {
            guard statusTextField.text != "" else {
                statusTextField.shake()
                return
            }
            statusText = statusTextField.text!
            statusLabel.text = "\(statusText ?? "")"
            setStatusButton.setTitle("Show status", for: .normal)
            self.statusTextField.removeFromSuperview()
            NSLayoutConstraint.deactivate([
                topConstrain, leadingConstrain, trailingConstrain, textHeight
            ].compactMap( {$0} ))
        }
        self.delegate?.buttonAction(inputTextIsVisible: self.statusTextField.isHidden) { [weak self] in
            self?.statusTextField.isHidden.toggle()
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        let status: String = textField.text ?? ""
        print("Новый статус = \(status)")
    }
}

    // MARK: - EXTENSIONS

extension ProfileTableHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // СПРЯТАТЬ КЛАВИАТУРУ ПО RETURN
        self.endEditing(true)
        return false
    }
}

extension ProfileTableHeaderView: UIGestureRecognizerDelegate { // ПРИКОСНОВЕНИЕ К АВАТАР
    
    private func setupTapGesture() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleTapGesture(_:)))
        self.avatarImageView.addGestureRecognizer(self.tapGestureRecognizer)
        self.avatarImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.tapGestureRecognizer === gestureRecognizer else { return }
        delegate?.delegateAction(cell: self)
    }
}

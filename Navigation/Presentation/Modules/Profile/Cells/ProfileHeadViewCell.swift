//
//  ProfileHeadViewCell.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import UIKit

class ProfileHeadViewCell: UITableViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask

        return view
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        self.contentView.addSubview(self.backView)
        self.backView.addSubview(self.profileHeaderView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let topConstraint = self.backView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let leadingConstraint = self.backView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let trailingConstraint = self.backView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let bottomConstraint = self.backView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
   
        let viewTopConstraint = self.profileHeaderView.topAnchor.constraint(equalTo: self.backView.topAnchor)
        let viewLeadingConstraint = self.profileHeaderView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor)
        let viewTrailingConstraint = self.profileHeaderView.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor)
        self.heightConstraint = self.backView.heightAnchor.constraint(equalToConstant: 236) // высота
        let viewBottomConstraint = self.profileHeaderView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -16)

        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, bottomConstraint, trailingConstraint,
            viewTopConstraint, viewLeadingConstraint, viewTrailingConstraint, viewBottomConstraint,
            self.heightConstraint
        ].compactMap( {$0} )) // Активация констрейнов
    }
}

extension ProfileHeadViewCell: ProfileHeaderViewProtocol { // разширение разширения вью

    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) {
        self.heightConstraint?.constant = inputTextIsVisible ? 266 : 236
        

        UIView.animate(withDuration: 0.2, delay: 0.0) { // замедляем открытие/закрытие текстового поля
            self.contentView.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}
    

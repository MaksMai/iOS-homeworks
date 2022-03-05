//
//  AvatarView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 04.03.2022.
//

import UIKit

class AvatarView: UIView {

    
    override init(frame: CGRect) { // Выводим обьекты во view
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) { // восстанавливаем интерфейс
        fatalError("init(coder:) yas not been")
    }

    func createSubviews() {  // добавляем обьекты ао вьюшку
        self.backgroundColor = .black
        self.alpha = 0.5
    }
    
}

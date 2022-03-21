//
//  Extension + String.swift
//  Navigation
//
//  Created by Maksim Maiorov on 15.03.2022.
//

import Foundation

extension String { // валидация email
    
    var isValidEmail: Bool {
         let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
         return testEmail.evaluate(with: self)
      }
}

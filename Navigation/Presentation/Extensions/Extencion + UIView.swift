//
//  Extencion + UIView.swift
//  Navigation
//
//  Created by Maksim Maiorov on 15.03.2022.
//

import UIKit


extension UIView { // SHAKE TEXTFIELD
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = 3
        animation.duration = 0.07
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}

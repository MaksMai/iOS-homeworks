//
//  Setupable.swift
//  Navigation
//
//  Created by Maksim Maiorov on 24.02.2022.
//

import Foundation

protocol ViewModelProtocol {}

protocol Setupable {
    func setup(with viewModel: ViewModelProtocol)
}

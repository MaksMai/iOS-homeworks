//
//  News.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import Foundation

struct News: ViewModelProtocol { // НОВОСТИ
    var author: String
    var description: String
    var image: String
    var likes: Int
    var views: Int
}

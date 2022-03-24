//
//  News.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import Foundation

struct News: Decodable { // Создаем структуру Post

    struct Article: Decodable  {
        var author: String
        var description: String
        var image: String
        var likes: String
        var views: String 

        enum CodingKeys: String, CodingKey {
            case author, description, image, likes, views
        }
    }

    let articles: [Article] // массив статей
}

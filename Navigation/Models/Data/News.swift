//
//  News.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import Foundation

struct News: Decodable { // Создаем структуру Новостной ленты

    struct Article: Decodable  {
        let author: String
        let description: String
        let image: String
        let likes: String
        let views: String

        enum CodingKeys: String, CodingKey {
            case author, description, image, likes, views
        }
    }

    let articles: [Article] // массив статей  Новостной ленты
}

//
//  News.swift
//  Navigation
//
//  Created by Maksim Maiorov on 25.02.2022.
//

import Foundation

struct News: Decodable { // Создаем структуру новостей
    var author: String // никнейм автора публикации
    var description: String // текст публикации
    var image: String // имя картинки из каталога Assets.xcassets
    var likes: Int // количество лайков
    var views: Int // количество просмотров
    
//    struct Article: Decodable  {
//        var author: String // никнейм автора публикации
//        var description: String // текст публикации
//        var image: String // имя картинки из каталога Assets.xcassets
//        var likes: String // количество лайков
//        var views: String // количество просмотров
//
//        enum CodingKeys: String, CodingKey {
//            case author, description, image, likes, views
//        }
//    }
//
//    let articles: [Article] // массив статей
}

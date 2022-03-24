//
//  TabBarControllerViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 10.02.2022.
//

import UIKit

// I-й способ !!! с использованием TabBarController

final class TabBarController: UITabBarController {
  
    private enum TabBarItem: Int {  // Инкапсулируем имена и иконки
        case feed
        case profile
      
        var title: String {  // Имена вкладок
            switch self {
            case .feed:
                return "Лента"
            case .profile:
                return "Профиль"
            }
        }
      
        var iconName: String {  // Иконки вкладок
            switch self {
            case .feed:
                return "house"
            case .profile:
                return "person.crop.circle"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()  // Загружаем TabBarController
    }
   
    private func setupTabBar() { // Метод добавления NavigationController в TabBarController
      
        let dataSource: [TabBarItem] = [.feed, .profile]  // Добавляем навигационные контроллеры в массив панели вкладок
       
        self.viewControllers = dataSource.map { // Инициализируем выбор из панелей вкладок
            switch $0 {
            case .feed:
                let feedViewController = FeedViewController()   // Инициализируем панель вкладок
                feedViewController.title = TabBarItem.feed.title  // Добавляем заголовок
                return self.wrappedInNavigationController(with: FeedViewController(), title: $0.title) // возвращаем пользовательский интерфейса
            case .profile:
                let profileViewController = ProfileViewController()
                profileViewController.title = TabBarItem.profile.title
                return self.wrappedInNavigationController(with: profileViewController, title: $0.title)
            }
        }
      
        self.viewControllers?.enumerated().forEach {  // Настроим внешний вид
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
 
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {   // Метод обертка UIViewController в NavigationController
        return UINavigationController(rootViewController: with)
        
    }
}

//
//  TabBarControllerViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 10.02.2022.
//

import UIKit

// I-й способ !!! с использованием TabBarController

final class TabBarController: UITabBarController {
    
    // MARK: - PROPERTIES
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
    
    // MARK: LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()  // Загружаем TabBarController
    }
   
    // MARK: - SETUP SUBVIEW
    private func setupTabBar() { // Метод добавления NavigationController в TabBarController
        
        let dataSource: [TabBarItem] = [.feed, .profile]  // Добавляем навигационные контроллеры в массив панели вкладок
       
        self.viewControllers = dataSource.map { // Инициализируем выбор из панелей вкладок
            switch $0 {
            case .feed:
                let feedViewController = FeedViewController()   // Инициализируем панель вкладок
                return UINavigationController(rootViewController: feedViewController) // возвращаем пользовательский интерфейса
            case .profile:
                let changeViewController = ProfileViewController()
                return UINavigationController(rootViewController: changeViewController)
            }
        }
      
        self.viewControllers?.enumerated().forEach {  // Настроим внешний вид
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
}

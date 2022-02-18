//
//  TabBarControllerViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 10.02.2022.
//

import UIKit

// I-й способ !!! с использованием TabBarController

final class TabBarController: UITabBarController {
    // Инкапсулируем имена и иконки
    private enum TabBarItem: Int {
        case feed
        case profile
        // Имена вкладок
        var title: String {
            switch self {
            case .feed:
                return "Лента"
            case .profile:
                return "Профиль"
            }
        }
        // Иконки вкладок
        var iconName: String {
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
        // Загружаем TabBarController
        self.setupTabBar()
    }
    // Метод добавления NavigationController в TabBarController
    private func setupTabBar() {
        // Добавляем навигационные контроллеры в массив панели вкладок
        let dataSource: [TabBarItem] = [.feed, .profile]
        // Инициализируем выбор из панелей вкладок
        self.viewControllers = dataSource.map {
            switch $0 {
            case .feed:
                // Инициализируем панель вкладок
                let feedViewController = FeedViewController()
                // Добавляем заголовок
                feedViewController.title = TabBarItem.feed.title
                // возвращаем пользовательский интерфейса
                return self.wrappedInNavigationController(with: FeedViewController(), title: $0.title)
            case .profile:
                let profileViewController = ProfileViewController()
                // Добавляем заголовок
                profileViewController.title = TabBarItem.profile.title
                
                return self.wrappedInNavigationController(with: profileViewController, title: $0.title)
            }
        }
        // Настроим внешний вид
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
    // Метод обертка UIViewController в NavigationController
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
        
    }
}

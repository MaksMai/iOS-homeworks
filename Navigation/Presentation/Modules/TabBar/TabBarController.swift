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
    
    private enum TabBarItem: Int {
        case feed
        case profile
      
        var title: String {  // ИМЕНА
            switch self {
            case .feed:
                
                return "Лента"
            case .profile:
                
                return "Профиль"
            }
        }

        var iconName: String {  // ИКОНКИ
            switch self {
            case .feed:
                
                return "house"
            case .profile:
                
                return "person.crop.circle"
            }
        }
    }
    
    // MARK: - LIFECIRCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
   
    // MARK: - SETUP SUBVIEW
    
    private func setupTabBar() {
        
        let dataSource: [TabBarItem] = [.feed, .profile]
       
        self.viewControllers = dataSource.map {
            switch $0 {
            case .feed:
                let feedViewController = FeedViewController()
                
                return UINavigationController(rootViewController: feedViewController)
            case .profile:
                let profileViewController = ProfileViewController()
                
                return UINavigationController(rootViewController: profileViewController)
            }
        }
      
        self.viewControllers?.enumerated().forEach { 
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
}

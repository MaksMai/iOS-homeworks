//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Maksim Maiorov on 04.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 3.В (AppDelegate.swift)  SceneDelegate добавьте UITabBarController. Добавьте в него два UINavigationController. Первый будет показывать ленту пользователя, а второй — профиль.
        
        // Создаем окно взаимодействия пользователя с приложением
        // I-й способ !!! с использованием TabBarController
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController = TabBarController()
        
        // II-й способ с использованием SceneDelegate
        // Устанавливаем панель вкладок пользовательского интерфейса
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//        window?.rootViewController = createTabBarController()
//        window?.makeKeyAndVisible()
    }
    
    // Создаем панель вкладок
//    func createTabBarController() -> UITabBarController {
//        // Инициализируем панель вкладок
//        let tabBarController = UITabBarController()
//        // Настроим внешний вид
//        UITabBar.appearance().backgroundColor = .clear
//        UITabBar.appearance().tintColor = .blue
//        // Добавляем навигационные контроллеры в массив панели вкладок
//        tabBarController.viewControllers = [createFeedViewController(), createProfileViewController()]
//        // Возвращаем панель вкладок
//        return tabBarController
//    }
    
    // Создаем навигационный контроллер для ленты пользователя
//    func createFeedViewController() -> UINavigationController {
//        // Инициализирую новую ленту для контроллера
//        let feedViewController = FeedViewController()
//        // Добавляем заголовок
//        feedViewController.title = "Лента"
//        // Настраиваем кнопку
//        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
//        // возвращаем пользовательский интерфейса
//        return UINavigationController(rootViewController: feedViewController)
//    }
    
    // Создаем навигационный контроллер для профиля пользователя
//    func createProfileViewController() -> UINavigationController {
//        // Инициализирую новую ленту для контроллера
//        let profileViewController = ProfileViewController()
//        // Добавляем заголовок
//        profileViewController.title = "Профиль"
//        // Настраиваем кнопку
//        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
//        // возвращаем пользовательский интерфейс
//        return UINavigationController(rootViewController: profileViewController)
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


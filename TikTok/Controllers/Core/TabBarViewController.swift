//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        settingControllers()
    }

    private func settingControllers() {
        let homeNavController = setUpHomeNavController(HomeViewController())
        let exploreNavController = setUpExploreNavController(ExploreViewController())
        let cameraController = setUpCameraController(CameraViewController())
        let notificationsNavController = setUpNotificationNavController(NotificationsViewController())
        let profileNavController = setUpProfileNavController(ProfileViewController())

        setViewControllers(
            [homeNavController,
             exploreNavController,
             cameraController,
             notificationsNavController,
             profileNavController],
            animated: false)
    }
    
    private func setUpHomeNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        navController.navigationBar.backgroundColor = .clear
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        return navController
    }
    
    private func setUpExploreNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        return navController
    }
    
    private func setUpCameraController(_ viewController: UIViewController) -> UIViewController {
        viewController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 3)
        return viewController
    }
    
    private func setUpNotificationNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 4)
        return navController
    }
    
    private func setUpProfileNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
        return navController
    }

}

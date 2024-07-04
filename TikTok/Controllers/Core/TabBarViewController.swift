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

        setUpControllers()
    }

    private func setUpControllers() {
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        let exploreNavigationController = UINavigationController(rootViewController: ExploreViewController())
        exploreNavigationController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        let cameraController = CameraViewController()
        cameraController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 3)
        let notificationsNavigationController = UINavigationController(rootViewController: NotificationsViewController())
        notificationsNavigationController.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 4)
        let profileNavigationController = UINavigationController(rootViewController: ProfileViewController())
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)

        setViewControllers(
            [homeNavigationController,
             exploreNavigationController,
             cameraController,
             notificationsNavigationController,
             profileNavigationController],
            animated: false)
    }

}

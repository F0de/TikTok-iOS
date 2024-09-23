//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Влад Тимчук on 01.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var signInPresented = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingControllers()
    }

    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false)
        }
    }
    
    private func settingControllers() {
        let homeNavController = setUpHomeNavController(HomeViewController())
        let exploreNavController = setUpExploreNavController(ExploreViewController())
        let cameraNavController = setUpCameraNavController(CameraViewController())
        let notificationsNavController = setUpNotificationNavController(NotificationsViewController())
        
        var urlString: String?
        if let cachedURLString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedURLString
        }
        let profileNavController = setUpProfileNavController(ProfileViewController(
            user: User(
                id: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? "",
                name: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? "Me",
                profilePictureURL: URL(string: urlString ?? "")
            )
        ))

        setViewControllers(
            [homeNavController,
             exploreNavController,
             cameraNavController,
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
        navController.navigationItem.backButtonDisplayMode = .minimal
        return navController
    }
    
    private func setUpExploreNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        navController.navigationItem.backButtonDisplayMode = .minimal
        return navController
    }
    
    private func setUpCameraNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 3)
        navController.navigationBar.backgroundColor = .clear
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .white
        navController.navigationItem.backButtonDisplayMode = .minimal
        return navController
    }
    
    private func setUpNotificationNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 4)
        navController.navigationBar.tintColor = .label
        navController.navigationItem.backButtonDisplayMode = .minimal
        return navController
    }
    
    private func setUpProfileNavController(_ viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
        navController.navigationItem.backButtonDisplayMode = .minimal
        navController.navigationBar.tintColor = .label
        return navController
    }

}

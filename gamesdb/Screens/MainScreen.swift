//
//  ViewController.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 21.01.21.
//

import UIKit

class MainScreen: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
        selectedIndex = 1 // start on middle tab (Home)
    }

    private func setupVCs() {
        viewControllers = [
            createNavigationController(for: SearchScreen(), title: "Search", image: UIImage(systemName: "magnifyingglass")!),
            createNavigationController(for: HomeScreen(), title: "Home", image: UIImage(systemName: "house")!),
            createNavigationController(for: ProfileScreen(), title: "Profile", image: UIImage(systemName: "person")!)
        ]
    }
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationCtr = UINavigationController(rootViewController: rootViewController)
        navigationCtr.tabBarItem.title = title
        navigationCtr.tabBarItem.image = image
        navigationCtr.isNavigationBarHidden = true
        // for when the navigation bar is not hidden:
//        rootViewController.title = title
//        navigationCtr.navigationBar.prefersLargeTitles = true
        return navigationCtr
    }

}

//
//  TabBarViewController.swift
//  MoviesMVVM
//
//  Created by Админ on 18.01.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Constants.Colors.orangeColor
        tabBar.unselectedItemTintColor = UIColor.white
        
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: ProfileViewController())

        vc1.tabBarItem.image = UIImage(systemName: "film")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "film.fill")
        vc2.tabBarItem.image = UIImage(systemName: "safari")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "safari.fill")
        vc3.tabBarItem.image = UIImage(systemName: "person")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        vc1.title = "Main"
        vc2.title = "Search"
        vc3.title = "Profile"
        
        setViewControllers([vc1,vc2,vc3], animated: true)
    }


}


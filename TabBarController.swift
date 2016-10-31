//
//  TabBarController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Home tab
        let tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        tweetsNavigationController.tabBarItem.title = "Home"
        tweetsNavigationController.tabBarItem.image = UIImage(named: "home")
        
        // Me tab
        let meNavigationController = storyboard.instantiateViewController(withIdentifier: "MeNavigationController") as! UINavigationController
        meNavigationController.tabBarItem.title = "Me"
        meNavigationController.tabBarItem.image = UIImage(named: "me")
        
        viewControllers = [tweetsNavigationController, meNavigationController]
        
        // Customize Tab bar colours
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(red: 94/255, green: 195/255, blue: 1, alpha: 1.0)
        tabBarAppearance.barTintColor = UIColor.white
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.unselectedItemTintColor = UIColor.darkGray
    }
}

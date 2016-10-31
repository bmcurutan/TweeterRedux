//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Customize Navigation bar colors
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor(red: 94/255, green: 195/255, blue: 1, alpha: 1.0)
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Home tab
        let tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        tweetsNavigationController.tabBarItem.title = "Home"
        tweetsNavigationController.tabBarItem.image = UIImage(named: "home")
        
        // Me tab
        let meNavigationController = storyboard.instantiateViewController(withIdentifier: "MeNavigationController") as! UINavigationController
        meNavigationController.tabBarItem.title = "Me"
        meNavigationController.tabBarItem.image = UIImage(named: "me")

        // Create Tab bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [tweetsNavigationController, meNavigationController]
        
        // Customize Tab bar colours
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(red: 94/255, green: 195/255, blue: 1, alpha: 1.0)
        tabBarAppearance.barTintColor = UIColor.white
        tabBarAppearance.unselectedItemTintColor = UIColor.darkGray
        
        window?.makeKeyAndVisible()

        if nil != User.currentUser {
            print("There is a current user") 
            window?.rootViewController = tabBarController
        }
        
        NotificationCenter.default.addObserver(forName: User.userDidLogoutNotification, object: nil, queue: OperationQueue.main) { (notification: Notification) -> Void in
            let loginViewController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance.handleOpenUrl(url as NSURL)
        return true
    }
}


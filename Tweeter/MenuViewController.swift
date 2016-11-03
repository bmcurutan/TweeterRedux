//
//  MenuViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/1/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
        let userNavigationController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        //blueNavigationController = storyboard.instantiateViewController(withIdentifier: "BlueViewController")
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(userNavigationController)
        //viewControllers.append(blueNavigationController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // TODO 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Home Timeline"
        case 1:
            cell.textLabel?.text = "Profile"
        case 2:
            cell.textLabel?.text = "Mentions"
        default:
            break
        }
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

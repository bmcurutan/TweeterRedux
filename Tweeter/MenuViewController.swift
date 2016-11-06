//
//  MenuViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/1/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum SelectionType: Int {
    case profile = 0, home, mentions, signout
    static var count: Int { return SelectionType.signout.hashValue + 1}
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userNavController = storyboard.instantiateViewController(withIdentifier: "UserNavigationController")
        //let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        //let tweetsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        viewControllers.append(userNavController)
        
        let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        tweetsViewController.timelineType = .home
        viewControllers.append(tweetsViewController)
        
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsViewController.timelineType = .mentions
        viewControllers.append(mentionsViewController)
        /*let tweetsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let tweetsViewController = tweetsNavController.topViewController as! TweetsViewController
        tweetsViewController.timelineType = .home*/
        
        //let mentionsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        //let mentionsViewController = tweetsNavController.topViewController as! TweetsViewController
        //mentionsViewController.timelineType = .mentions
        
        
        
        //viewControllers.append(tweetsNavController)
        
        hamburgerViewController.contentViewController = userNavController
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectionType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch SelectionType(rawValue: indexPath.row)! {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as! ProfileMenuCell
            cell.user = User.currentUser
            return cell
        case .home:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath) as! IconMenuCell
            cell.iconImageView.image = UIImage(named: "home")
            cell.titleLabel.text = "Home"
            return cell
        case .mentions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath) as! IconMenuCell
            cell.iconImageView.image = UIImage(named: "at")
            cell.titleLabel.text = "Mentions"
            return cell
        case .signout:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath) as! IconMenuCell
            cell.iconImageView.image = UIImage(named: "stop")
            cell.titleLabel.text = "Sign Out"
            return cell
        }
    }
}

extension MenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        if SelectionType(rawValue: indexPath.row) == .profile {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
        else if SelectionType(rawValue: indexPath.row) == .signout {
            TwitterClient.sharedInstance.logout()
        } else {
            // Embed in navigation controller
            let viewController = viewControllers[indexPath.row]
            let navController = UINavigationController(rootViewController: viewController)
            hamburgerViewController.contentViewController = navController
        }
    }
}

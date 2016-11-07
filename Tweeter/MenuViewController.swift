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

final class MenuViewController: UIViewController {

    //static let sharedInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    
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
        
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        viewControllers.append(userViewController)
        
        let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        tweetsViewController.timelineType = .home
        viewControllers.append(tweetsViewController)
        
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsViewController.timelineType = .mentions
        viewControllers.append(mentionsViewController)
        
        let navController = UINavigationController(rootViewController: tweetsViewController)
        hamburgerViewController.contentViewController = navController
    }
    
    // MARK: - Private Methods
    
    @objc fileprivate func onUserLongPress(_ sender: UILongPressGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController")
        present(viewController, animated: true, completion: nil)
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
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onUserLongPress(_:)))
            longPressGesture.delegate = self
            cell.addGestureRecognizer(longPressGesture)

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
        
        switch SelectionType(rawValue: indexPath.row)! {
        case .signout:
            TwitterClient.sharedInstance.logout()
            break
            
        default: // .home, .mentions
            // Embed in navigation controller
            let viewController = viewControllers[indexPath.row]
            let navController = UINavigationController(rootViewController: viewController)
            hamburgerViewController.contentViewController = navController
        }
    }
}

extension MenuViewController: UIGestureRecognizerDelegate {
    // Do nothing
}

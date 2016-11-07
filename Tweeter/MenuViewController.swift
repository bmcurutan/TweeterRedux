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
        
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        viewControllers.append(userViewController)
        
        let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        tweetsViewController.timelineType = .home
        viewControllers.append(tweetsViewController)
        
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsViewController.timelineType = .mentions
        viewControllers.append(mentionsViewController)
        
        let navController = UINavigationController(rootViewController: tweetsViewController)
        //hamburgerViewController.contentViewController = navController TODO uncomment
        hamburgerViewController.contentViewController = userViewController
    }
    
    // MARK: - Private Methods
    
    @objc fileprivate func onUserLongPress(_ sender: UILongPressGestureRecognizer) {
        //let listView = UIView(frame: CGRect(origin: <#T##CGPoint#>, size: <#T##CGSize#>))
        print("TESTTEST")
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
            //TODO uncomment TwitterClient.sharedInstance.logout()
            break
            
        default:
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

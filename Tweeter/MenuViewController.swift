//
//  MenuViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/1/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum SelectionType: Int {
    case profile = 0, timeline, mentions
    static var count: Int { return SelectionType.mentions.hashValue + 1}
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
        let tweetsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        let mentionsNavController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(userNavController)
        viewControllers.append(tweetsNavController)
        viewControllers.append(mentionsNavController)
        
        // Default to home timeline
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
        case .timeline:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath) as! IconMenuCell
            cell.iconImageView.image = UIImage(named: "home")
            cell.titleLabel.text = "Timeline"
            return cell
        case .mentions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath) as! IconMenuCell
            cell.iconImageView.image = UIImage(named: "at")
            cell.titleLabel.text = "Mentions"
            return cell
        }
    }
}

extension MenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

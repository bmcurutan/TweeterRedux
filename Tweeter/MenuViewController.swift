//
//  MenuViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/1/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum MenuCellType: Int {
    case profile = 0, timeline, mentions
    static var count: Int { return MenuCellType.mentions.hashValue + 1}
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
        let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") // TODO
        
        viewControllers.append(userViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(mentionsViewController)
        
        // Default to home timeline
        hamburgerViewController.contentViewController = tweetsViewController
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch MenuCellType(rawValue: indexPath.row)! {
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
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

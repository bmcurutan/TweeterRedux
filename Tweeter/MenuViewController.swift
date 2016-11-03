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
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") // tODO
        
        viewControllers.append(userViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(mentionsViewController)
        
        hamburgerViewController.contentViewController = userViewController
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath)
            //cell.textLabel?.text = "Profile"
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuCell", for: indexPath)
            //cell.textLabel?.text = 1 == indexPath.row ? "Home Timeline" : "Mentions"
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

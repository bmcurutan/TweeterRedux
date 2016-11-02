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
    
    private var redNavigationController: UIViewController!
    private var greenNavigationController: UIViewController!
    private var blueNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        redNavigationController = storyboard.instantiateViewController(withIdentifier: "RedViewController")
        greenNavigationController = storyboard.instantiateViewController(withIdentifier: "GreenViewController")
        blueNavigationController = storyboard.instantiateViewController(withIdentifier: "BlueViewController")
        
        viewControllers.append(redNavigationController)
        viewControllers.append(greenNavigationController)
        viewControllers.append(blueNavigationController)
        
        hamburgerViewController.contentViewController = redNavigationController
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = "Cell \(indexPath.row+1)"
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

//
//  TweetDetailsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum CellType: Int {
    case details = 0, actions
    static var count: Int { return CellType.actions.hashValue + 1}
}

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" || segue.identifier == "replySegue2" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! NewTweetViewController
            viewController.user = User.currentUser
            viewController.replyTweet = tweet
            
        }
    }
}

extension TweetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row)! {
        case CellType.details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
            cell.tweet = tweet
            return cell
            
        case CellType.actions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionsCell", for: indexPath) as! ActionsCell
            cell.tweet = tweet
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count
    }
}

extension TweetDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

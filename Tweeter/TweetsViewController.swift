//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // For pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - IBAction
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    // MARK: - Private Methods
    func onPullToRefresh(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let navigationController = segue.destination as! UINavigationController TODO
        
        if "detailsSegue" == segue.identifier {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            let viewController = segue.destination as! TweetDetailsViewController
            viewController.tweet = tweet
            
        } else if "newTweetSegue" == segue.identifier {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! NewTweetViewController
            viewController.user = User.currentUser
        
        } else if "replySegue" == segue.identifier {
            let replyButton = sender as! UIButton
            let tweet = tweets[replyButton.tag]
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! NewTweetViewController
            viewController.tweet = tweet
            viewController.user = User.currentUser
        }
    }
}

// MARK: - UITableViewDataSource

extension TweetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.replyButton.tag = indexPath.row // TODO Fix??
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count 
    }
}

// MARK: - UITableViewDelegate

extension TweetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


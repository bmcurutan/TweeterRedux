//
//  UserViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum UserSection: Int {
    case details = 0, tweets
    static var count: Int { return UserSection.tweets.hashValue + 1}
}

final class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    var user: User? = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user?.name

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // For pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefreshWith(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TwitterClient.sharedInstance.timelineForUserWith(screenname: (user?.screenname)!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "userSegue" == segue.identifier {
            onUserSegue(segue: segue, sender: sender)
            
        } else if "detailsSegue" == segue.identifier {
            onDetailsSegue(segue: segue, sender: sender)
            
        } else if "newTweetSegue" == segue.identifier {
            onNewTweetSegue(segue: segue, sender: sender)
            
        } else if "replySegue" == segue.identifier {
            onReplySegue(segue: segue, sender: sender)
        }
    }
    
    // MARK: - Segues
    
    fileprivate func onUserSegue(segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let tweet = tweets[button.tag]
        let viewController = segue.destination as! UserViewController
        
        viewController.user = tweet.user
    }
    
    fileprivate func onDetailsSegue(segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        let viewController = segue.destination as! TweetDetailsViewController
        
        //viewController.delegate = self
        viewController.tweet = tweet
        
        //self.delegate = viewController
    }
    
    fileprivate func onNewTweetSegue(segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        //viewController.delegate = self
        viewController.user = User.currentUser
    }
    
    fileprivate func onReplySegue(segue: UIStoryboardSegue, sender: Any?) {
        let replyButton = sender as! UIButton
        let tweet = tweets[replyButton.tag]
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        //viewController.delegate = self
        viewController.replyTweet = tweet
        viewController.user = User.currentUser
    }
    
    // MARK: - Private Methods
    
    @objc fileprivate func onPullToRefreshWith(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.timelineForUserWith(screenname: (user?.screenname!)!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (UserSection(rawValue: indexPath.section)!) {
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.user = user
            return cell
            
        case .tweets:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            cell.replyButton.tag = indexPath.row
            cell.retweetButton.tag = indexPath.row
            cell.favoriteButton.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserSection(rawValue: section)! == .tweets ? tweets.count : 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (UserSection(rawValue: section)! == .tweets ? " " : nil)
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (nil != self.tableView(tableView, titleForHeaderInSection: section) ? 8 : 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

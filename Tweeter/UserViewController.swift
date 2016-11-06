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
        
        self.title = (user == User.currentUser ? "Me" : user?.name)

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
        if "detailsSegue" == segue.identifier {
            onDetailsSegue(segue: segue, sender: sender)
            
        } else if "newTweetSegue" == segue.identifier { 
            onNewTweetSegue(segue: segue, sender: sender)
            
        } else if "replySegue" == segue.identifier {
            onReplySegue(segue: segue, sender: sender)
        }
    }
    
    // MARK: - IBAction
    
    /*@IBAction func onTweetButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewTweetViewController") as! NewTweetViewController
        
        viewController.delegate = self
        viewController.user = User.currentUser
        
        self.present(viewController, animated: true, completion: nil)
    }*/
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        let favoriteButton = sender as! UIButton
        let tweet = tweets[favoriteButton.tag]
        
        if tweet.favorited { // Currently favorited, so unfavorite action
            TwitterClient.sharedInstance.removeFavoriteWith(id: tweet.id,
                                                            success: { () -> () in
                                                                print("Tweet successfully unfavorited")
                                                                tweet.favorited = false
                                                                tweet.favoritesCount -= 1
                                                                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Favorite action
            TwitterClient.sharedInstance.addFavoriteWith(id: tweet.id,
                                                         success: { () -> () in
                                                            print("Tweet successfully favorited")
                                                            tweet.favorited = true
                                                            tweet.favoritesCount += 1
                                                            
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let tweet = tweets[retweetButton.tag]
        
        if tweet.retweeted { // Currently retweeted, so unretweet action
            TwitterClient.sharedInstance.unretweetWith(id: tweet.id,
                                                       success: { () -> () in
                                                        print("Tweet successfully unretweeted")
                                                        tweet.retweeted = false
                                                        tweet.retweetCount -= 1
                                                        
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Retweet action
            TwitterClient.sharedInstance.retweetWith(id: tweet.id,
                                                     success: { () -> () in
                                                        print("Tweet successfully retweeted")
                                                        tweet.retweeted = true
                                                        tweet.retweetCount += 1
                                                        
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    // MARK: - Segues
    
    fileprivate func onDetailsSegue(segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        let viewController = segue.destination as! TweetDetailsViewController
        
        viewController.delegate = self
        viewController.tweet = tweet
        //self.delegate = viewController
    }
    
    fileprivate func onNewTweetSegue(segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        viewController.delegate = self
        viewController.user = User.currentUser
    }
    
    fileprivate func onReplySegue(segue: UIStoryboardSegue, sender: Any?) {
        let replyButton = sender as! UIButton
        let tweet = tweets[replyButton.tag]
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        viewController.delegate = self
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

// MARK: - NewTweetViewControllerDelegate

extension UserViewController: NewTweetViewControllerDelegate {
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didAddTweet tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}

// MARK: - TweetDetailsViewControllerDelegate

extension UserViewController: TweetDetailsViewControllerDelegate {
    
    func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, didUpdateTweet tweet: Tweet) {
        
        TwitterClient.sharedInstance.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
}



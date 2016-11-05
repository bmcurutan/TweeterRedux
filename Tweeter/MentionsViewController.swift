//
//  MentionsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 1/5/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class MentionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isHome: Bool = true // Default to home timeline
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // For pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefreshWith(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        TwitterClient.sharedInstance.mentionsTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - IBAction
    
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
    
    // MARK: - Private Methods
    
    @objc fileprivate func onPullToRefreshWith(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.mentionsTimeline(
            success: { (tweets: [Tweet]) -> () in
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
        /*if "detailsSegue" == segue.identifier {
         onDetailsSegue(segue: segue, sender: sender)
         
         } else if "newTweetSegue" == segue.identifier {
         onNewTweetSegue(segue: segue, sender: sender)
         
         } else if "replySegue" == segue.identifier {
         onReplySegue(segue: segue, sender: sender)
         }*/
    }
    
    // MARK: - Segues
    
    /*fileprivate func onDetailsSegue(segue: UIStoryboardSegue, sender: Any?) {
     let cell = sender as! TweetCell
     let indexPath = tableView.indexPath(for: cell)
     let tweet = tweets[indexPath!.row]
     
     let viewController = segue.destination as! TweetDetailsViewController
     viewController.delegate = self
     viewController.tweet = tweet
     
     self.delegate = viewController
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
     }*/
}

// MARK: - UITableViewDataSource

extension MentionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.replyButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

// MARK: - UITableViewDelegate

extension MentionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


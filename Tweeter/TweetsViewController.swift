//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

protocol TweetsViewControllerDelegate: class {
    func tweetsViewController(tweetsViewController: TweetsViewController, didUpdateTweet tweet: Tweet)
}

final class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: TweetsViewControllerDelegate?
    
    var dataController: Tweet!
    var timelineType: TimelineType! {
        didSet {
            if nil == dataController {
                dataController = Tweet()
            }
            dataController.timelineType = timelineType
        }
    }
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = timelineType == .home ? "Home" : "Mentions"
        let button = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .plain, target: self, action: #selector(onToggleMenu(_:)))
        navigationItem.leftBarButtonItem = button
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        if nil != dataController.tweets {
            tweets = dataController.tweets
        } else {
            TwitterClient.sharedInstance.homeTimeline(
                success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            ) // TODO fix this hack
        }
    }
    
    // MARK: - Private Methods
    
    @objc fileprivate func onToggleMenu(_ sender: AnyObject) {
        HamburgerViewController.sharedInstance.toggleMenu()
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
        
        self.delegate?.tweetsViewController(tweetsViewController: self, didUpdateTweet: tweet)
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

        self.delegate?.tweetsViewController(tweetsViewController: self, didUpdateTweet: tweet)
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
    
    // MARK: - Segues
	
    fileprivate func onDetailsSegue(segue: UIStoryboardSegue, sender: Any?) {
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
    }
    
    @objc fileprivate func onUserTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        let tweet = tweets[(indexPath?.row)!]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        viewController.user = tweet.user
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TweetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.replyButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.tweet = tweets[indexPath.row]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onUserTap(_:)))
        tapGesture.delegate = self
        cell.profilePictureImageView.addGestureRecognizer(tapGesture)
        
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

// MARK: - NewTweetViewControllerDelegate

extension TweetsViewController: NewTweetViewControllerDelegate {
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didAddTweet tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}

// MARK: - TweetDetailsViewControllerDelegate

extension TweetsViewController: TweetDetailsViewControllerDelegate {
    
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

// MARK: - UIGestureRecognizerDelegate

extension TweetsViewController: UIGestureRecognizerDelegate {
    // Do nothing
}


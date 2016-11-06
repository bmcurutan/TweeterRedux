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

final class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - IBAction
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        if tweet.favorited { // Currently favorited, so unfavorite action
            TwitterClient.sharedInstance.removeFavoriteWith(id: tweet.id,
                success: { () -> () in
                    print("Tweet successfully unfavorited")
                    self.tweet.favorited = false

                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )

        } else { // Favorite action
            TwitterClient.sharedInstance.addFavoriteWith(id: tweet.id,
                success: { () -> () in
                    print("Tweet successfully favorited")
                    self.tweet.favorited = true

                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        if tweet.retweeted { // Currently retweeted, so unretweet action
            TwitterClient.sharedInstance.unretweetWith(id: tweet.id,
                success: { () -> () in
                    print("Tweet successfully unretweeted")
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Retweet action
            TwitterClient.sharedInstance.retweetWith(id: tweet.id,
                success: { () -> () in
                    print("Tweet successfully retweeted")
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*guard segue.identifier == "replySegue" || segue.identifier == "actionReplySegue" else {
            return
        }
        
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        viewController.user = User.currentUser
        viewController.replyTweet = tweet*/
    }
}

// MARK: - UITableViewDataSource

extension TweetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row)! {
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
            cell.tweet = tweet
            return cell
            
        case .actions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionsCell", for: indexPath) as! ActionsCell
            cell.tweet = tweet
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count
    }
}

// MARK: - UITableViewDelegate

extension TweetDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

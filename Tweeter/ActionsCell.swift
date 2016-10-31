//
//  ActionsCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/29/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class ActionsCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            favoriteButton.isSelected = tweet.favorited
            favoritesLabel.text = "\(tweet.favoritesCount) FAVORITES"
            retweetButton.isSelected = tweet.retweeted
            retweetsLabel.text = "\(tweet.retweetCount) RETWEETS"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // TODO move this to view controller
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        // UI updates
        favoriteButton.isSelected = !tweet.favorited
        favoritesLabel.text = !tweet.favorited ? "\(tweet.favoritesCount+1) FAVORITES" : "\(tweet.favoritesCount-1) FAVORITES"
        
        if tweet.favorited { // Currently favorited, so unfavorite action
            TwitterClient.sharedInstance.removeFavoriteWith(id: tweet.id, success: { () -> () in
                print("Tweet successfully unfavorited")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Favorite action
            TwitterClient.sharedInstance.addFavoriteWith(id: tweet.id, success: { () -> () in
                print("Tweet successfully favorited")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        retweetsLabel.text = !tweet.retweeted ? "\(tweet.retweetCount+1) RETWEETS" : "\(tweet.retweetCount-1) RETWEETS"
        
        if tweet.retweeted { // Currently retweeted, so unretweet action
            TwitterClient.sharedInstance.unretweetWith(id: tweet.id, success: { () -> () in
                print("Tweet successfully unretweeted")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Retweet action
            TwitterClient.sharedInstance.retweetWith(id: tweet.id, success: { () -> () in
            print("Tweet successfully retweeted")
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
                }
            )
        }
    }
}

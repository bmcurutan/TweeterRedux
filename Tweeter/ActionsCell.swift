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
            favoritesLabel.text = tweet.favoritesCount == 1 ? "\(tweet.favoritesCount) FAVORITE" : "\(tweet.favoritesCount) FAVORITES"
            retweetButton.isSelected = tweet.retweeted
            retweetsLabel.text = tweet.retweetCount == 1 ? "\(tweet.retweetCount) RETWEET" : "\(tweet.retweetCount) RETWEETS"
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        favoriteButton.isSelected = !tweet.favorited
        
        if !favoriteButton.isSelected {
            tweet.favoritesCount -= 1
            
        } else {
            tweet.favoritesCount += 1
        }
        
        favoritesLabel.text = tweet.favoritesCount == 1 ? "\(tweet.favoritesCount) FAVORITE" : "\(tweet.favoritesCount) FAVORITES"
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        
        if !retweetButton.isSelected {
            tweet.retweetCount -= 1
        } else {
            tweet.retweetCount += 1
        }
        
        retweetsLabel.text = tweet.retweetCount == 1 ? "\(tweet.retweetCount) RETWEET" : "\(tweet.retweetCount) RETWEETS"
    }
}

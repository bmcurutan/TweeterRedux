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
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        favoriteButton.isSelected = !tweet.favorited
        
        if !favoriteButton.isSelected {
            self.tweet.favorited = false
            self.tweet.favoritesCount -= 1
            
        } else {
            self.tweet.favorited = true
            self.tweet.favoritesCount += 1
        }
        
        self.favoritesLabel.text = "\(self.tweet.favoritesCount) FAVORITES"
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        
        if !retweetButton.isSelected {
            self.tweet.retweeted = false
            self.tweet.retweetCount -= 1
        } else {
            self.tweet.retweeted = true
            self.tweet.retweetCount += 1
        }
        
        self.retweetsLabel.text = "\(self.tweet.retweetCount) RETWEETS"
    }
}

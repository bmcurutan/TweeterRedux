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
        favoritesLabel.text = !tweet.favorited ? "\(tweet.favoritesCount+1) FAVORITES" : "\(tweet.favoritesCount-1) FAVORITES"
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        retweetsLabel.text = !tweet.retweeted ? "\(tweet.retweetCount+1) RETWEETS" : "\(tweet.retweetCount-1) RETWEETS"
    }
}

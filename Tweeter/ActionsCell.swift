//
//  ActionsCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/29/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class ActionsCell: UITableViewCell {

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
        favoriteButton.isSelected = !tweet.favorited
        
        if tweet.favorited { // Currently favorited, so unfavorite action
            TwitterClient.sharedInstance.removeFavoriteWithId(tweet.id, success: { () -> () in
                print("Tweet successfully unfavorited")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Favorite action
            TwitterClient.sharedInstance.addFavoriteWithId(tweet.id, success: { () -> () in
                print("Tweet successfully favorited")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
        
        TwitterClient.sharedInstance.retweetWithId(tweet.id, success: { () -> () in
            print("Tweet successfully retweeted")
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
}

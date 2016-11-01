//
//  TweetCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            favoriteButton.isSelected = tweet.favorited
            retweetButton.isSelected = tweet.retweeted
            
            if let timestamp = tweet.timestamp {
                timestampLabel.text = timestamp
            }
            
            tweetTextLabel.text = tweet.text
            
            if let user = tweet.user {
                if let name = user.name,
                    let screenname = user.screenname {
                    let nameAttributes = [
                        NSForegroundColorAttributeName: UIColor.black,
                        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)
                    ]
                    
                    let screennameAttributes = [
                        NSForegroundColorAttributeName: UIColor.lightGray,
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)
                    ]

                    let mutableAttributedText = NSMutableAttributedString(string: "\(name)", attributes: nameAttributes)
                    mutableAttributedText.append(NSAttributedString(string: " @\(screenname)", attributes: screennameAttributes))
                    
                    nameLabel.attributedText = mutableAttributedText
                }
                
                profilePictureImageView.setImageWith(user.profilePictureURL!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = 5
        profilePictureImageView.clipsToBounds = true
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        favoriteButton.isSelected = !tweet.favorited
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        retweetButton.isSelected = !tweet.retweeted
    }
}



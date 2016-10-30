//
//  TweetCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            timestampLabel.text = tweet.timestamp
            tweetTextLabel.text = tweet.text
            
            if let user = tweet.user {
                if let name = user.name,
                    let screenname = user.screenname {
                    nameLabel.text = "\(name) @\(screenname)" // TODO UI
                }
                profilePictureImageView.setImageWith(user.profilePictureUrl!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = 5
        profilePictureImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

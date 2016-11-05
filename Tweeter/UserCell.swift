//
//  UserCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var accountsButton: UIButton!
    
    var user: User! {
        didSet {
            if let profileBannerURL = user.profileBannerURL {
                bannerImageView.setImageWith(profileBannerURL)
            }
            
            nameLabel.text = user.name
            
            if let profilePictureURL = user.profilePictureURL {
                profileImageView.setImageWith(profilePictureURL)
            }
            
            if let screenname = user.screenname {
                screennameLabel.text = "@\(screenname)"
            }
            
            let countAttributes = [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)
            ]
            let countTypeAttributes = [
                NSForegroundColorAttributeName: UIColor.lightGray,
                NSFontAttributeName: UIFont.systemFont(ofSize: 11.0)
            ]
            
            if let count = user.countTweets {
                let mutableTweetsText = NSMutableAttributedString(string: "\(count)", attributes: countAttributes)
                mutableTweetsText.append(NSMutableAttributedString(string: "\nTWEETS", attributes: countTypeAttributes))
                tweetsCountLabel.attributedText = mutableTweetsText
            }
            
            if let count = user.countFollowing {
                let mutableFollowingText = NSMutableAttributedString(string: "\(count)", attributes: countAttributes)
                mutableFollowingText.append(NSMutableAttributedString(string: "\nFOLLOWING", attributes: countTypeAttributes))
                followingCountLabel.attributedText = mutableFollowingText
            }
            
            if let count = user.countFollowers {
                let mutableFollowersText = NSMutableAttributedString(string: "\(count)", attributes: countAttributes)
                mutableFollowersText.append(NSMutableAttributedString(string: "\nFOLLOWERS", attributes: countTypeAttributes))
                followersCountLabel.attributedText = mutableFollowersText
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }
}

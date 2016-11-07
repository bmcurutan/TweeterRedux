//
//  UserCountsCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

// TODO pull this out into a view instead of a cell
final class UserCountsCell: UITableViewCell {

    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var accountsButton: UIButton!
    
    var user: User! {
        didSet {
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
        
        followingCountLabel.layer.borderWidth = 1
        followingCountLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    }
}

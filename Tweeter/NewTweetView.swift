//
//  NewTweetView.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/29/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class NewTweetView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    var user: User! {
        didSet {
            nameLabel.text = user.name
            profilePictureImageView.setImageWith(user.profilePictureURL!)
            screennameLabel.text = user.screenname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tweetTextView.becomeFirstResponder()
        
        profilePictureImageView.layer.cornerRadius = 5
        profilePictureImageView.clipsToBounds = true
    }
}

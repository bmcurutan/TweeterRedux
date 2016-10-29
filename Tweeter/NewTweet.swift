//
//  NewTweet.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/29/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class NewTweet: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!

    var user: User! {
        didSet {
            nameLabel.text = user.name
            profilePictureImageView.setImageWith(user.profilePictureUrl!)
            screennameLabel.text = user.screenname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tweetTextField.becomeFirstResponder()
        
        profilePictureImageView.layer.cornerRadius = 5
        profilePictureImageView.clipsToBounds = true
    }
}

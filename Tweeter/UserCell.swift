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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var user: User! {
        didSet {
            if let profileBannerUrl = user.profileBannerUrl {
                bannerImageView.setImageWith(profileBannerUrl)
            }
            
            descriptionLabel.text = user.tagline
            locationLabel.text = user.location
            nameLabel.text = user.name
            
            if let profilePictureUrl = user.profilePictureUrl {
                profileImageView.setImageWith(profilePictureUrl)
            }
            
            if let screenname = user.screenname {
                screennameLabel.text = "@\(screenname)"
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

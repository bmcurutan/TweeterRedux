//
//  ProfileMenuCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/5/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class ProfileMenuCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var user: User! {
        didSet {
            if let profilePictureURL = user?.profilePictureURL {
                profileImageView.setImageWith(profilePictureURL)
            }
            nameLabel.text = user.name
            taglineLabel.text = user.tagline
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }
}

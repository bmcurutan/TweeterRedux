//
//  MeCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class MeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    
    var user: User! {
        didSet {
            nameLabel.text = user.name
            
            if let screenname = user.screenname {
                screennameLabel.text = "@\(screenname)"
            }
            
            if let profilePictureUrl = user.profilePictureUrl {
                profileImageView.setImageWith(profilePictureUrl)
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

//
//  User.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var profileUrl: NSURL?
    var screenname: String?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
    }
}

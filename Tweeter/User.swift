//
//  User.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class User: NSObject {

    var location: String?
    var name: String?
    var profileBannerUrl: URL?
    var profilePictureUrl: URL?
    var screenname: String?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        if let profileBannerUrlString = profileBannerUrlString {
            profileBannerUrl = URL(string: profileBannerUrlString)
        }
        
        location = dictionary["location"] as? String
        name = dictionary["name"] as? String
        
        let profilePictureUrlString = dictionary["profile_image_url_https"] as? String
        if let profilePictureUrlString = profilePictureUrlString {
            // Use higher res profile picture
            profilePictureUrl = URL(string: profilePictureUrlString.replacingOccurrences(of: "_normal", with: ""))
        }
        
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if nil == _currentUser {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }

            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary! as NSDictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}

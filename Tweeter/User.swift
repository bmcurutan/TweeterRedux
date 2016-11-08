//
//  User.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class User: NSObject {

    var dictionary: NSDictionary?
    var location: String?
    var name: String?
    var profileBannerURL: URL?
    var profilePictureURL: URL?
    var screenname: String?
    var tagline: String?
    
    var countTweets: Int?
    var countFollowing: Int?
    var countFollowers: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        location = dictionary["location"] as? String
        name = dictionary["name"] as? String
        
        let profileBannerURLString = dictionary["profile_banner_url"] as? String
        if let profileBannerURLString = profileBannerURLString {
            profileBannerURL = URL(string: profileBannerURLString)
        }
        
        let profilePictureURLString = dictionary["profile_image_url_https"] as? String
        if let profilePictureURLString = profilePictureURLString {
            // Use higher res profile picture
            profilePictureURL = URL(string: profilePictureURLString.replacingOccurrences(of: "_normal", with: ""))
        }
        
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        countTweets = dictionary["statuses_count"] as? Int
        countFollowing = dictionary["following"] as? Int
        countFollowers = dictionary["followers_count"] as? Int
    }
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    static var _currentUser: User?
    static var _otherUser: User?
    
    class var currentUser: User? {
        get {
            guard nil == _currentUser else {
                return _currentUser
            }
            
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? NSData
            
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                _currentUser = User(dictionary: dictionary as! NSDictionary)
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
    
    class var otherUser: User? {
        get {
            guard nil == _otherUser else {
                return _otherUser
            }
            
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "otherUserData") as? NSData
            
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: [])
                _otherUser = User(dictionary: dictionary as! NSDictionary)
            }
            
            return _otherUser
        }
        
        set(user) {
            _otherUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary! as NSDictionary, options: [])
                defaults.set(data, forKey: "otherUserData")
                
            } else {
                defaults.removeObject(forKey: "otherUserData")
            }
            
            defaults.synchronize()
        }
    }
}

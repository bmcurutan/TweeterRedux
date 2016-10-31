//
//  Tweet.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class Tweet: NSObject {
    
    var favorited = false
    var favoritesCount: Int = 0
    var id: NSNumber = 0
    var retweetCount: Int = 0
    var retweeted = false
    var text: String?
    var timestamp: String?
    var user: User?
    
    init(dictionary: NSDictionary) {
        favorited = (dictionary["favorited"] as? Bool)!
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = (dictionary["id"] as? NSNumber) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool)!
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y" //TODO
            if let timestampDate = formatter.date(from: timestampString) {
                formatter.dateStyle = .short
                timestamp = formatter.string(from: timestampDate)
            }
        }
        
        if let userDictionary = dictionary["user"] {
            user = User(dictionary: userDictionary as! NSDictionary)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}

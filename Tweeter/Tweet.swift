//
//  Tweet.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var favoritesCount: Int = 0
    var retweetCount: Int = 0
    var text: String?
    var timestamp: Date?
    
    init(dictionary: NSDictionary) {
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
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

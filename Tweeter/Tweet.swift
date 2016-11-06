//
//  Tweet.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/27/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum TimelineType: Int {
    case home = 0, mentions
}

final class Tweet: NSObject {
    
    var tweets: [Tweet]! 
    var timelineType: TimelineType! {
        didSet {
            if timelineType == .home {
                TwitterClient.sharedInstance.homeTimeline(
                    success: { (tweets: [Tweet]) -> () in
                        self.tweets = tweets
                    }, failure: { (error: Error) -> () in
                        print("error: \(error.localizedDescription)")
                    }
                )
            } else if timelineType == .mentions {
                TwitterClient.sharedInstance.mentionsTimeline(
                    success: { (tweets: [Tweet]) -> () in
                        self.tweets = tweets
                    }, failure: { (error: Error) -> () in
                        print("error: \(error.localizedDescription)")
                    }
                )
            }
        }
    }
    
    var favorited = false
    var favoritesCount: Int = 0
    var id: NSNumber = 0
    var retweetCount: Int = 0
    var retweeted = false
    var text: String?
    var timestamp: String! = ""
    var user: User?
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        favorited = (dictionary["favorited"] as? Bool)!
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = (dictionary["id"] as? NSNumber) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool)!
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let now = Date()
            timestamp = now.offsetFrom(dateString: timestampString)
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

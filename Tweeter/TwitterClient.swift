//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/26/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

// TODO put this in plist
let twitterConsumerKey = "STX1NC1rVeFsRJoyqgDl85mV8"
let twitterConsumerSecret = "2WyDKL8wqzGdBMIhfHzjThx6tz9likph82KXbK59mqQD3GPdIp"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL as URL!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }
    
    func currentAccount() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: { (Progress) -> Void in
            }, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary) // TODO remove
                
            }, failure: { (task: URLSessionTask?, error: Error) -> Void in
                print("Error getting current user")
            }
        )
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: { (Progress) -> Void in
            }, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
            }, failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
}

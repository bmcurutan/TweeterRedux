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
}

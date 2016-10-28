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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        // requestSerializer.removeAccessToken() TODO remove
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            if let token = requestToken?.token {
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
                let options = [UIApplicationOpenURLOptionUniversalLinksOnly: false]
                UIApplication.shared.open(authURL as! URL, options: options, completionHandler: nil)
            }
            
            }, failure: { (error: Error?) -> Void in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
            }
        )
    }
    
    func handleOpenUrl(_ url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
                //self.requestSerializer.saveAccessToken(accessToken)
            
                self.loginSuccess?()

            }, failure: { (error: Error?) -> Void in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
            }
        )
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

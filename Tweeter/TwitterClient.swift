//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/26/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

let twitterConsumerKey = "STX1NC1rVeFsRJoyqgDl85mV8"
let twitterConsumerSecret = "2WyDKL8wqzGdBMIhfHzjThx6tz9likph82KXbK59mqQD3GPdIp"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

final class TwitterClient: BDBOAuth1SessionManager {
    
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
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeter://oauth") as URL!, scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                if let token = requestToken?.token {
                    let authURL = NSURL(string: "https://api.twitter.com/oauth/authenticate?force_login=true&oauth_token=\(token)")
                    let options = [UIApplicationOpenURLOptionUniversalLinksOnly: false]
                    UIApplication.shared.open(authURL as! URL, options: options, completionHandler: nil)
                }
            },
            failure: { (error: Error?) -> Void in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
            }
        )
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(_ url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential?) -> Void in
                self.currentAccount(
                    success: { (user: User) -> () in
                        User.otherUser = User.currentUser
                        User.currentUser = user
                        self.loginSuccess?()
                    },
                    failure: { (error: Error) -> () in
                        self.loginFailure?(error)
                    }
                )
            
            },
            failure: { (error: Error?) -> Void in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
            }
        )
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user)
                
            }, failure: { (task: URLSessionTask?, error: Error) -> Void in
                print("Error getting current user")
            }
        )
    }
    
    // MARK: - Timelines
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
                
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    func timelineForUserWith(screenname: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String: AnyObject] = ["screen_name": screenname as AnyObject]
        get("1.1/statuses/user_timeline.json", parameters: parameters,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
                
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
                
            }, failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    // MARK: - Tweet
    
    func tweetWith(text: String, replyId: NSNumber?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String: AnyObject] = ["status": text as AnyObject]
        
        if 0 != replyId {
            parameters["in_reply_to_status_id"] = replyId
        }
        
        post("1.1/statuses/update.json", parameters: parameters,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                success()
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    // MARK: - Retweet
    
    func retweetWith(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                success()
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    func unretweetWith(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                success()
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    // MARK: - Favorite
    
    func addFavoriteWith(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String: AnyObject] = ["id": id as AnyObject]
        post("1.1/favorites/create.json", parameters: parameters,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                success()
            }, failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
    
    func removeFavoriteWith(id: NSNumber, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters: [String: AnyObject] = ["id": id as AnyObject]
        post("1.1/favorites/destroy.json", parameters: parameters,
            progress: { (Progress) -> Void in
                // Do nothing
            },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                success()
            },
            failure: { (task: URLSessionTask?, error: Error) -> Void in
                failure(error)
            }
        )
    }
}

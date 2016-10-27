//
//  LoginViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/26/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
                if let token = requestToken?.token {
                    let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
                    print(authURL)
                    let options = [UIApplicationOpenURLOptionUniversalLinksOnly: false]
                    UIApplication.shared.open(authURL as! URL, options: options, completionHandler: nil)
                }
                
            }, failure: { (error: Error?) -> Void in
                print("Failed to get request token")
            }
        )
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    }
    
    // MARK: - IBAction
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        client.login(success: { () -> () in
                print("I've logged in!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            }
        )
    }
}

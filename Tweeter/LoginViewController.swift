//
//  LoginViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/26/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.imageView?.contentMode = .scaleAspectFit
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
    }
    
    // MARK: - IBAction
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        client.login(
            success: { () -> () in
                print("I've logged in!")
                self.present(HamburgerViewController.sharedInstance, animated: true, completion: nil)
            
            }, failure: { (error: Error) -> () in
                print("Error: \(error.localizedDescription)")
            }
        )
    }
}

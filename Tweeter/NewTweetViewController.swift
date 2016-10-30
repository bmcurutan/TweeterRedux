//
//  NewTweetViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var countdownTextField: UITextField!
    @IBOutlet var newTweetView: NewTweetView!
    
    let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
    
    var countdown: Int = 140
    var replyTweet: Tweet?
    var retweetTweet: Tweet?
    var tweetText: String = ""
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let replyTweet = replyTweet,
           let screenname = replyTweet.user?.screenname {
            tweetText = "@\(screenname) "
        }
        
        if let retweetTweet = retweetTweet {
            if let name = retweetTweet.user?.name {
                tweetText += "\(name) "
            }
            
            if let screenname = retweetTweet.user?.screenname {
                tweetText += "@\(screenname) "
            }
            
            if let text = retweetTweet.text {
                tweetText += "\(text) "
            }
        }
        
        newTweetView.user = user
        newTweetView.tweetTextView.text = tweetText
        
        countdownTextField.text = "\(140 - tweetText.characters.count)"
    }

    // MARK: - IBAction
    
    @IBAction func onTweetButton(_ sender: AnyObject) {
        if countdown == 140 {
            onError("Tweet is empty. Please try again")
        }
            
        else if countdown < 0 {
            onError("Tweet is more than 140 characters. Please try again")
            
        } else {
            TwitterClient.sharedInstance.tweetWithText(tweetText, replyId: (replyTweet?.id)!, success: { () -> () in
                self.dismiss(animated: true, completion: nil)
                print("Tweet successfully posted")
                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )

        }
    }
    
    @IBAction func onTweetTextField(_ sender: AnyObject) {
        tweetText = newTweetView.tweetTextView.text!
        countdown = 140 - tweetText.characters.count
        countdownTextField.text = "\(countdown)"
    }
    
    // MARK: - UIAlert
    
    func onError(_ message: String) {
        alertController.message = message as String
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    // MARK: - IBAction
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

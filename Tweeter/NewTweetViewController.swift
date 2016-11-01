//
//  NewTweetViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

protocol NewTweetViewControllerDelegate: class {
    func newTweetViewController(newTweetViewController: NewTweetViewController, didAddTweet tweet: Tweet)
}

final class NewTweetViewController: UIViewController {

    @IBOutlet weak var countdownTextField: UITextField!
    @IBOutlet var newTweetView: NewTweetView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: NewTweetViewControllerDelegate?
    
    let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
    
    var countdown: Int = 140
    var replyTweet: Tweet?
    var retweetTweet: Tweet?
    var tweetText: String = ""
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        
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
        
        // Update countdown 
        countdown = 140 - tweetText.characters.count
        countdownTextField.text = "\(countdown)"
    }

    // MARK: - IBAction
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: AnyObject) {
        if countdown == 140 {
            onError("Tweet is empty. Please try again")
        }
            
        else if countdown < 0 {
            onError("Tweet is more than 140 characters. Please try again")
            
        } else {
            TwitterClient.sharedInstance.tweetWith(text: tweetText, replyId: replyTweet?.id,
                success: { () -> () in
                    print("Tweet successfully posted")
                
                    // Timestamp
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                    let nowString = formatter.string(from: Date())
                
                    let tweetDictionary: [String: AnyObject] = [
                        "favorited": false as AnyObject,
                        "favoritesCount": 0 as AnyObject,
                        // id not yet available
                        "retweetCount": 0 as AnyObject,
                        "retweeted": false as AnyObject,
                        "text": self.tweetText as AnyObject,
                        "created_at": nowString as AnyObject,
                        "user": self.user.dictionary as AnyObject
                    ]
                    let tweet = Tweet.init(dictionary: tweetDictionary as NSDictionary)
                
                    self.delegate?.newTweetViewController(newTweetViewController: self, didAddTweet: tweet)
                    self.dismiss(animated: true, completion: nil)
                    
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )

        }
    }
    
    // MARK: - UIAlert
    
    func onError(_ message: String) {
        alertController.message = message as String
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tweetText = tweetTextView.text!
        countdown = 140 - tweetText.characters.count
        countdownTextField.text = "\(countdown)"
    }
}

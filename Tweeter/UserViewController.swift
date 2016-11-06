//
//  UserViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum UserSection: Int {
    case details = 0, tweets
    static var count: Int { return UserSection.tweets.hashValue + 1}
}

final class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = 144
    var pageControl: UIPageControl! = UIPageControl(frame: CGRect(x: 0, y: 112, width: 38, height: 36))
    var scrollView: UIScrollView! = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 144))
    
    var tweets: [Tweet] = []
    var user: User? = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (user == User.currentUser ? "Me" : user?.name)

        setupScrollView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TwitterClient.sharedInstance.timelineForUserWith(screenname: (user?.screenname)!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    // MARK: - Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "detailsSegue" == segue.identifier {
            onDetailsSegue(segue: segue, sender: sender)
            
        } else if "newTweetSegue" == segue.identifier { 
            onNewTweetSegue(segue: segue, sender: sender)
            
        } else if "replySegue" == segue.identifier {
            onReplySegue(segue: segue, sender: sender)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        let favoriteButton = sender as! UIButton
        let tweet = tweets[favoriteButton.tag]
        
        if tweet.favorited { // Currently favorited, so unfavorite action
            TwitterClient.sharedInstance.removeFavoriteWith(id: tweet.id,
                                                            success: { () -> () in
                                                                print("Tweet successfully unfavorited")
                                                                tweet.favorited = false
                                                                tweet.favoritesCount -= 1
                                                                
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Favorite action
            TwitterClient.sharedInstance.addFavoriteWith(id: tweet.id,
                                                         success: { () -> () in
                                                            print("Tweet successfully favorited")
                                                            tweet.favorited = true
                                                            tweet.favoritesCount += 1
                                                            
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let tweet = tweets[retweetButton.tag]
        
        if tweet.retweeted { // Currently retweeted, so unretweet action
            TwitterClient.sharedInstance.unretweetWith(id: tweet.id,
                                                       success: { () -> () in
                                                        print("Tweet successfully unretweeted")
                                                        tweet.retweeted = false
                                                        tweet.retweetCount -= 1
                                                        
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
            
        } else { // Retweet action
            TwitterClient.sharedInstance.retweetWith(id: tweet.id,
                                                     success: { () -> () in
                                                        print("Tweet successfully retweeted")
                                                        tweet.retweeted = true
                                                        tweet.retweetCount += 1
                                                        
                }, failure: { (error: Error) -> () in
                    print("error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupScrollView() {
        // Actual scroll view
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        // Page control
        pageControl.center.x = view.center.x
        pageControl.numberOfPages = 2
        view.addSubview(pageControl)
        
        // Page 1
        let bannerImageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        if let profileBannerURL = user?.profileBannerURL {
            bannerImageView1.setImageWith(profileBannerURL)
        }
        scrollView.addSubview(bannerImageView1)
        
        // Page 2
        if let profileBannerURL = user?.profileBannerURL {
            let bannerImageView2 = UIImageView(frame: CGRect(x: width, y: 0, width: width, height: height))
            bannerImageView2.setImageWith(profileBannerURL)
            scrollView.addSubview(bannerImageView2)
        }
        
        if let tagline = user?.tagline {
            let taglineLabel = UILabel(frame: CGRect(x: width + 8, y: 8, width: width - 16, height: 16))
            let taglineAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
            ]
            let attributedText = NSAttributedString(string: "\(tagline)", attributes: taglineAttributes)
            taglineLabel.attributedText = attributedText
            taglineLabel.numberOfLines = 0
            taglineLabel.lineBreakMode = .byWordWrapping
            taglineLabel.setNeedsLayout()
            scrollView.addSubview(taglineLabel)
        }
        
        if let location = user?.location {
            let pinImageView = UIImageView(frame: CGRect(x: width + 8, y: 32, width: 16, height: 16))
            pinImageView.image = UIImage(named: "pin")
            scrollView.addSubview(pinImageView)
            
            let locationLabel = UILabel(frame: CGRect(x: width + 32, y: 32, width: width - 40, height: 16))
            let locationAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
            ]
            let attributedText = NSAttributedString(string: "\(location)", attributes: locationAttributes)
            locationLabel.attributedText = attributedText
            locationLabel.numberOfLines = 0
            locationLabel.lineBreakMode = .byWordWrapping
            locationLabel.setNeedsLayout()
            scrollView.addSubview(locationLabel)
        }
    }
    
    // MARK: - Segues
    
    fileprivate func onDetailsSegue(segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TweetCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        let viewController = segue.destination as! TweetDetailsViewController
        
        viewController.delegate = self
        viewController.tweet = tweet
        //self.delegate = viewController
    }
    
    fileprivate func onNewTweetSegue(segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        viewController.delegate = self
        viewController.user = User.currentUser
    }
    
    fileprivate func onReplySegue(segue: UIStoryboardSegue, sender: Any?) {
        let replyButton = sender as! UIButton
        let tweet = tweets[replyButton.tag]
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.topViewController as! NewTweetViewController
        
        viewController.delegate = self
        viewController.replyTweet = tweet
        viewController.user = User.currentUser
    }
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (UserSection(rawValue: indexPath.section)!) {
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.user = user
            return cell
            
        case .tweets:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            cell.replyButton.tag = indexPath.row
            cell.retweetButton.tag = indexPath.row
            cell.favoriteButton.tag = indexPath.row
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserSection(rawValue: section)! == .tweets ? tweets.count : 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (UserSection(rawValue: section)! == .tweets ? " " : nil)
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (nil != self.tableView(tableView, titleForHeaderInSection: section) ? 8 : 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NewTweetViewControllerDelegate

extension UserViewController: NewTweetViewControllerDelegate {
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didAddTweet tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}

// MARK: - TweetDetailsViewControllerDelegate

extension UserViewController: TweetDetailsViewControllerDelegate {
    
    func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, didUpdateTweet tweet: Tweet) {
        
        TwitterClient.sharedInstance.homeTimeline(
            success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
            }
        )
    }
}

// MARK: - UIScrollViewDelegate 

extension UserViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page : Int = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = page
    }
}

//
//  UserViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/30/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum UserSection: Int {
    case counts = 0, tweets
    static var count: Int { return UserSection.tweets.hashValue + 1}
}

final class UserViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // Scroll View
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = 136
    var pageControl: UIPageControl! = UIPageControl(frame: CGRect(x: 0, y: 104, width: 38, height: 36))
    var scrollView: UIScrollView! = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 136))
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    var tweets: [Tweet] = []
    var user: User? = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (user == User.currentUser ? "Me" : user?.name)
        let button = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .plain, target: self, action: #selector(onToggleMenu(_:)))
        navigationItem.leftBarButtonItem = button

        if let profileBannerURL = user?.profileBannerURL {
            bannerImageView.setImageWith(profileBannerURL)
        }
        setupScrollView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        blurEffectView.alpha = 0
        blurEffectView.frame = bannerImageView.bounds
        bannerImageView.addSubview(blurEffectView)
    }
    
    // TODO move this
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
    
    @objc fileprivate func onToggleMenu(_ sender: AnyObject) {
        HamburgerViewController.sharedInstance.toggleMenu()
    }
    
    fileprivate func setupScrollView() {
        // Actual scroll view
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        // Page control
        pageControl.center.x = view.center.x
        pageControl.numberOfPages = 2
        view.addSubview(pageControl)
        
        // Page 1
        if let profilePictureURL = user?.profilePictureURL {
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 8, width: 60, height: 60))
            profileImageView.setImageWith(profilePictureURL)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            profileImageView.center.x = view.center.x
            scrollView.addSubview(profileImageView)
        }
        
        if let name = user?.name {
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 76, width: width - 16, height: 16))
            let nameAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)
            ]
            let attributedText = NSAttributedString(string: "\(name)", attributes: nameAttributes)
            nameLabel.attributedText = attributedText
            nameLabel.numberOfLines = 0
            nameLabel.lineBreakMode = .byWordWrapping
            nameLabel.sizeToFit()
            nameLabel.center.x = view.center.x
            scrollView.addSubview(nameLabel)
        }
        
        if let screenname = user?.screenname {
            let screennameLabel = UILabel(frame: CGRect(x: 0, y: 96, width: width - 16, height: 16))
            let screennameAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
                ]
            let attributedText = NSAttributedString(string: "@\(screenname)", attributes: screennameAttributes)
            screennameLabel.attributedText = attributedText
            screennameLabel.numberOfLines = 0
            screennameLabel.lineBreakMode = .byWordWrapping
            screennameLabel.sizeToFit()
            screennameLabel.center.x = view.center.x
            scrollView.addSubview(screennameLabel)
        }
        
        // Page 2
        let locationLabel = UILabel(frame: CGRect(x: width + 8, y: 40, width: width - 16, height: 16))
        if let location = user?.location {
            let locationAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
            ]
            let attributedText = NSAttributedString(string: "\(location)", attributes: locationAttributes)
            locationLabel.attributedText = attributedText
            locationLabel.numberOfLines = 0
            locationLabel.lineBreakMode = .byWordWrapping
            locationLabel.sizeToFit()
            locationLabel.center.x = width / 2 + width
            locationLabel.center.y = height / 2
            scrollView.addSubview(locationLabel)
        }
        
        if let tagline = user?.tagline {
            let taglineLabel = UILabel(frame: CGRect(x: width, y: locationLabel.frame.origin.y - 20, width: width - 16, height: 16))
            let taglineAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
            ]
            let attributedText = NSAttributedString(string: "\(tagline)", attributes: taglineAttributes)
            taglineLabel.attributedText = attributedText
            taglineLabel.numberOfLines = 0
            taglineLabel.lineBreakMode = .byWordWrapping
            taglineLabel.sizeToFit()
            taglineLabel.center.x = view.center.x + width
            scrollView.addSubview(taglineLabel)
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
        case .counts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCountsCell", for: indexPath) as! UserCountsCell
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
        return (UserSection(rawValue: section)! == .counts ? 1 : tweets.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSection.count
    }
}

extension UserViewController: UITableViewDelegate {
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let velocity = self.scrollView.panGestureRecognizer.velocity(in: self.scrollView.superview).x
        let duration: TimeInterval = Double(width / velocity)
        
        if self.scrollView.panGestureRecognizer.translation(in: self.scrollView.superview).x > 0 {
            // Left (Page 1)            
            UIView.animate(withDuration: duration, animations: {
                self.bannerImageView.alpha = 1
            })
            
        } else {
            // Right (Page 2)
            UIView.animate(withDuration: duration, animations: {
                self.bannerImageView.alpha = 0.4
            })
        }
        
        if tableView.contentOffset.y < 0 {
            bannerImageView.frame.size.height = height - self.tableView.contentOffset.y
            UIView.animate(withDuration: 0.5, animations: { 
                self.blurEffectView.alpha = 1
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page : Int = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = page
        
        bannerImageView.frame.size = CGSize(width: width, height: height)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 0 })
    }
}

extension UserViewController: UIGestureRecognizerDelegate {
    // Do nothing
}

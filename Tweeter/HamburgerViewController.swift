//
//  HamburgerViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/31/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

final class HamburgerViewController: UIViewController {

    static let sharedInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3,
                animations: {
                    self.leftMarginConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    func toggleMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [],
                animations: {
                    if self.leftMarginConstraint.constant == 0 { // Open menu
                        self.leftMarginConstraint.constant = self.view.frame.size.width - 60
                    } else { // Close menu
                        self.leftMarginConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
            }
        )
    }
    
    // MARK: - IBAction
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftMarginConstraint.constant
            
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
            
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [],
                animations: {
                    if velocity.x > 0 { // Open menu
                        self.leftMarginConstraint.constant = self.view.frame.size.width - 60
                    } else { // Close menu
                        self.leftMarginConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
}

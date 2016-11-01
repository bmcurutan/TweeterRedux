//
//  HamburgerViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/31/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

// TODO fix initial view controller
class HamburgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            UIView.animate(withDuration: 0.3,
                animations: {
                    if velocity.x > 0 {
                        self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                    } else {
                        self.leftMarginConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
                }
            )
        }
    }
}

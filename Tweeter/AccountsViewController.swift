//
//  AccountsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/6/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Private Methods
    
    fileprivate func titleCell(cell: UITableViewCell) -> UITableViewCell {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)
        ]
        let attributedText = NSAttributedString(string: "Accounts", attributes: attributes)
        cell.textLabel?.attributedText = attributedText
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    fileprivate func accountCell(cell: UITableViewCell, user: User) -> UITableViewCell {
        if let name = user.name,
            let screenname = user.screenname {
            let nameAttributes = [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)
            ]
            
            let screennameAttributes = [
                NSForegroundColorAttributeName: UIColor.lightGray,
                NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)
            ]
            
            let mutableAttributedText = NSMutableAttributedString(string: "\(name)", attributes: nameAttributes)
            mutableAttributedText.append(NSAttributedString(string: " @\(screenname)", attributes: screennameAttributes))
            
            cell.textLabel?.attributedText = mutableAttributedText
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    fileprivate func dismissCell(cell: UITableViewCell) -> UITableViewCell {
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
        ]
        let attributedText = NSAttributedString(string: "Dismiss", attributes: attributes)
        cell.textLabel?.attributedText = attributedText
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        return cell
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        
        if indexPath.row == 0 {
            return titleCell(cell: cell)
        
        } else if indexPath.row < User.accounts.count + 1 {
            return accountCell(cell: cell, user: User.accounts[indexPath.row-1])
            
        } else {
            return dismissCell(cell: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.accounts.count + 2
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row == 1 ? true : false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            User.accounts.remove(at: indexPath.row-1)
            
            guard User.accounts.count > 0 else {
                TwitterClient.sharedInstance.logout()
                return
            }
            
            tableView.reloadData()
        }
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > User.accounts.count {
            dismiss(animated: true, completion: nil)
        }
    }
}

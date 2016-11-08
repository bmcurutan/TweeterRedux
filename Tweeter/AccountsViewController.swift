//
//  AccountsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/6/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum AccountCellType: Int {
    case title = 0, current, other, signout
    static var count: Int { return AccountCellType.signout.hashValue + 1}
}

final class AccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Private Methods
    
    fileprivate func titleCellFor(cell: UITableViewCell) -> UITableViewCell {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)
        ]
        let attributedText = NSAttributedString(string: "Accounts", attributes: attributes)
        cell.textLabel?.attributedText = attributedText
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    fileprivate func accountCellFor(cell: UITableViewCell, user: User) -> UITableViewCell {
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
        }
        
        return cell
    }
    
    fileprivate func addAccountCellFor(cell: UITableViewCell) -> UITableViewCell {
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
        ]
        let attributedText = NSAttributedString(string: "Add Account", attributes: attributes)
        cell.textLabel?.attributedText = attributedText
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        return cell
    }
    
    fileprivate func dismissCellFor(cell: UITableViewCell) -> UITableViewCell {
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        
        switch AccountCellType(rawValue: indexPath.row)! {
        case .title:
            return titleCellFor(cell: cell)
        
        case .current:
            cell = accountCellFor(cell: cell, user: User.currentUser!)
            cell.accessoryType = .checkmark
            return cell
            
        case .other:
            if let otherUser = User.otherUser {
                return accountCellFor(cell: cell, user: otherUser)
            } else {
                return addAccountCellFor(cell: cell)
            }
            
        case .signout:
            return dismissCellFor(cell: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountCellType.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (AccountCellType.current.rawValue == indexPath.row ||
            AccountCellType.other.rawValue == indexPath.row ? true : false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if AccountCellType.current.rawValue == indexPath.row {
                // Log out current user
                TwitterClient.sharedInstance.logout()
                
            } else if AccountCellType.other.rawValue == indexPath.row {
                User.otherUser = nil
                tableView.reloadData()
            }
            
            tableView.reloadData()
        }
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        if AccountCellType.other.rawValue == indexPath.row {
            if nil == User.otherUser {
                TwitterClient.sharedInstance.login(
                    success: { () -> () in
                        print("I've logged in!")
                        tableView.reloadData()
                        
                    }, failure: { (error: Error) -> () in
                        print("Error: \(error.localizedDescription)")
                    }
                )
                
            } else {
                let temp: User = User.currentUser!
                User.currentUser = User.otherUser
                User.otherUser = temp
            }
            
            dismiss(animated: true, completion: nil)
            
        } else if AccountCellType.signout.rawValue == indexPath.row {
            dismiss(animated: true, completion: nil)
        }
    }
}

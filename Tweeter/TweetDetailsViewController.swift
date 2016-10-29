//
//  TweetDetailsViewController.swift
//  Tweeter
//
//  Created by Bianca Curutan on 10/24/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

enum CellType: Int {
    case details = 0, totals, actions
    static var count: Int { return CellType.actions.hashValue + 1}
}

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    
    @IBAction func onHomeButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension TweetDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row)! {
        case CellType.details:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
            cell.textLabel?.text = "SOME DETAILS!"
            return cell
        case CellType.totals:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalsCell", for: indexPath) as! TotalsCell
            cell.tweet = tweet
            return cell
        case CellType.actions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionsCell", for: indexPath)
            cell.textLabel?.text = "ACTION!"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count
    }
}

extension TweetDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

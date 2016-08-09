//
//  PartyLineTableViewController.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/23/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class PartyLineTableViewController: UITableViewController {
    
    var ronvu: Ronvu!
    private var comments: [Comment]?
    
    // MARK: - Notification Selector
    
    func commentsQueryFinish(notification: NSNotification){
        if let newComments = notification.object as? [Comment] {
            if newComments.count > 0 {
                if self.comments != nil {
                    self.comments = self.comments! + newComments
                } else {
                    self.comments = newComments
                }
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Query for comments
        Downloader.sharedDownloader.queryForComments(onRonvu: ronvu)
        
        // Add Notification Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PartyLineTableViewController.commentsQueryFinish(_:)), name: Notification.CommentsNotification, object: nil)
        
        // Dynamically adjust row height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source
    
    private struct Storyboard {
        static let CommentCellReuseIdentifier = "commentCell" // Put this string in storyboard for prototype cell type want to use
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CommentCellReuseIdentifier, forIndexPath: indexPath) as! CommentTableViewCell

        // Configure the cell...
        if comments != nil {
            let comment = comments![indexPath.row]
            cell.comment = comment
        }
        cell.selectionStyle = .None

        return cell
    }

}

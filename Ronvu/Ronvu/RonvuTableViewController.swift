//
//  RonvuTableViewController.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/2/16.
//  Copyright © 2016 JGilly. All rights reserved.
//
// FIX : Add error/info splash page if there are no ronvus to display in the table



import UIKit
import MGSwipeTableCell

struct Constants {
    struct Colors {
        static let ronvuTeal = UIColor(red:0.19, green:0.82, blue:0.87, alpha:1.0)
        static let cellSeparatorDark = UIColor(red:0.82, green:0.82, blue:0.84, alpha:1.0)
        static let cellSeparatorLight = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0)
        static let ronvuCoral = UIColor(red:0.99, green:0.41, blue:0.40, alpha:1.0)
    }
    
    struct Segues {
        static let showRonvuDetail = "showRonvuDetailSegue"
    }
    
    enum SelectedView {
        case PartyLine
        case WhenAndWhere
    }
}

class RonvuTableViewController: UITableViewController, MGSwipeTableCellDelegate, RonvuTableViewCellDelegate
{
    // Model - An array of Ronvus
    var ronvus: [Ronvu]?
    
    var segueingCell: RonvuTableViewCell?
    var detailToShow: Constants.SelectedView?
    
    private func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        Downloader.sharedDownloader.queryForRonvus()
        sender?.endRefreshing()
    }
    
    private func rsvpForCellAtIndexPath(indexPath: NSIndexPath, rsvp: Bool){
        // Update Database, an rsvp should remove it from local/invites and send to Going (or not)
        if let ronvu = ronvus?[indexPath.row] {
            Downloader.sharedDownloader.sendRSVPForRonvu(ronvu, rsvp: rsvp)
            self.ronvus?.removeAtIndex(indexPath.row)    // FIXME: removing ronvu here instead of reloading data from model so request for newer works , change?

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    private func createCellSeparatorView(cell: MGSwipeTableCell) -> UIView {
        let cellSeparator = UIView(frame: CGRect(origin: CGPointZero, size: cell.bounds.size) )
        cellSeparator.backgroundColor = UIColor.clearColor()
        
        let darkLine = UIView(frame: CGRect(x: 0, y: cell.bounds.height - 4, width: cell.bounds.width, height: 1) )
        darkLine.backgroundColor = Constants.Colors.cellSeparatorDark
        cellSeparator.addSubview(darkLine)
        
        let lightLine = UIView(frame: CGRect(x: 0, y: cell.bounds.height - 3, width: cell.bounds.width, height: 3) )
        lightLine.backgroundColor = Constants.Colors.cellSeparatorLight
        cellSeparator.addSubview(lightLine)
        
        return cellSeparator
    }

    
    // MARK: - Notification SEL
    
    // FIXME: - this should be updated with data checks etc, if update notifications to pass as dictionary do something like this ..
    //    var tweets = [Tweet]()
    //    var tweetArray: NSArray?
    //    if let dictionary = results as? NSDictionary {
    //        if let tweets = dictionary[TwitterKey.Tweets] as? NSArray {
    //            tweetArray = tweets
    //        } else if let tweet = Tweet(data: dictionary) {
    //            tweets = [tweet]
    //        }
    //    } else if let array = results as? NSArray {
    //        tweetArray = array
    //    }
    //    if tweetArray != nil {
    //    for tweetData in tweetArray! {
    //    if let tweet = Tweet(data: tweetData as? NSDictionary) {
    //    tweets.append(tweet)
    //    }
    //    }
    //    }
    func queryFinish(notification: NSNotification){
        if let newRonvus = notification.object as? [Ronvu] {
            if newRonvus.count > 0 {
                if self.ronvus != nil {
                    self.ronvus = newRonvus + self.ronvus!
                } else {
                    self.ronvus = newRonvus
                }
                tableView.reloadData()
            }
        }
    }
    
    // FIXME: do something with success/ error? Log? Post comment on party line stating RSVP yes/no
    func rsvpFinish(notification: NSNotification){
        if let success = notification.object as? Bool {
            if success {
                print("rsvp success")
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query for Ronvus - add options for local(popularity/time)/invites/going?
        Downloader.sharedDownloader.queryForRonvus()
        
        // Add observers for query, rsvp
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RonvuTableViewController.queryFinish(_:)), name: Notification.QueryForRonvusNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RonvuTableViewController.rsvpFinish(_:)), name: Notification.RSVPForRonvuNotification, object: nil)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == Constants.Segues.showRonvuDetail {
            let vc = segue.destinationViewController as! RonvuDetailViewController
            if let cell = segueingCell {
                if let indexPath = tableView.indexPathForCell(cell){
                    if let ronvu = ronvus?[indexPath.row]{
                        vc.ronvu = ronvu
                    }
                }
            }
            if let destinationDetail = detailToShow {
                vc.detailToShow = destinationDetail
            }
        }
        
    }
    
}

// MARK: - Table view data source

extension RonvuTableViewController
{
    private struct Storyboard {
        static let RonvuCellReuseIdentifier = "Ronvu" // Put this string in storyboard for prototype cell type want to use
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ronvus?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RonvuCellReuseIdentifier, forIndexPath: indexPath) as! RonvuTableViewCell
        
        // Configure the cell...
        if ronvus != nil {
            let ronvu = ronvus![indexPath.row]
            cell.ronvu = ronvu
        }
        cell.delegate = self
        cell.ronvuCellDelegate = self
        cell.selectionStyle = .None
             
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RonvuTableViewCell.defaultHeight
    }
}

// MARK: - Cell Delegate

extension RonvuTableViewController
{
    // MARK: - Swipe Cell Delegate Methods

    //Delegate method to enable/disable swipe gestures, return YES if swipe is allowed
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    /*
     * Delegate method to setup the swipe buttons and swipe/expansion settings
     * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
     * @return Buttons array
     */
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        swipeSettings.transition = .Static
        swipeSettings.keepButtonsSwiped = false
        swipeSettings.bottomMargin = 0

        expansionSettings.buttonIndex = 0
        expansionSettings.fillOnTrigger = true
        expansionSettings.threshold = 1.0; // At reatio threshold = 1 no white space shows before trigger
        expansionSettings.expansionLayout = MGSwipeExpansionLayout.Center
        expansionSettings.triggerAnimation.easingFunction = MGSwipeEasingFunction.CubicOut
        expansionSettings.animationDuration = 0.2 // Can play with animation time, default = 0.2
        
        weak var weakSelf = self
        let font = UIFont(name: "HelveticaNeue-Light", size:26.0)
        
        if (direction == MGSwipeDirection.LeftToRight) {
            let color = Constants.Colors.ronvuTeal
            
            let yesButton = MGSwipeButton(title: "✔︎ In!", backgroundColor: color, padding:50) { (sender) in
                if let indexPath = weakSelf?.tableView.indexPathForCell(sender){
                    weakSelf?.rsvpForCellAtIndexPath(indexPath, rsvp: true)
                }
                return false //don't autohide to improve delete animation
            }
            
            yesButton.addSubview( createCellSeparatorView(cell) )
            yesButton.titleLabel?.font = font
            
            return [yesButton]
            
        } else if (direction == MGSwipeDirection.RightToLeft) {
            let color = Constants.Colors.ronvuCoral
            
            let noButton = MGSwipeButton(title: "✕ Out", backgroundColor: color, padding:50) { (sender) in
                if let indexPath = weakSelf?.tableView.indexPathForCell(sender){
                    weakSelf?.rsvpForCellAtIndexPath(indexPath, rsvp: false)
                }
                return false //don't autohide to improve delete animation
            }
            
            noButton.addSubview( createCellSeparatorView(cell) )
            noButton.titleLabel?.font = font
            
            return [noButton]
        }

        return nil
    }
    
    // Delegate method invoked when the current swipe state changes
    func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {
        var str = ""
        switch (state) {
        case MGSwipeState.None: str = "None"
        case MGSwipeState.SwipingLeftToRight: str = "SwippingLeftToRight"
        case MGSwipeState.SwipingRightToLeft: str = "SwippingRightToLeft"
        case MGSwipeState.ExpandingLeftToRight: str = "ExpandingLeftToRight"
        case MGSwipeState.ExpandingRightToLeft: str = "ExpandingRightToLeft"
        }
        print("Swipe state: " + str + "::: Gesture: " + (gestureIsActive ? "Active" : "Ended") )
    }
    
    // MARK: - Ronvu Cell Delegate Methods
    
    // Delegate method invoked from RSVP buttons
    func ronvuTableCellRSVPButton(cell: MGSwipeTableCell!, sentRSVP rsvp: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
           
            weak var weakSelf = self
            let delay = 0.2 * Double(NSEC_PER_SEC) // Delay after expanding swipe before fading cell out, nanosec/sec
            
            if rsvp == true{
                print("got in RSVP true")
                cell.showSwipe(.LeftToRight, animated: true) { (success) in
                    print("in swipeCell.showSwipe")
                    if success {
                        print("success")
                    }
                }
                
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    weakSelf?.rsvpForCellAtIndexPath(indexPath, rsvp: true)
                }
            } else {
                print("got in RSVP false")
                cell.showSwipe(.RightToLeft, animated: true) { (success) in
                    print("in swipeCell.showSwipe")
                    if success {
                        print("success")
                    }
                }
                
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    weakSelf?.rsvpForCellAtIndexPath(indexPath, rsvp: false)
                }
            }
        }
    }
    
    func segueToDetail(fromCell cell: RonvuTableViewCell, toDetail detailView: Constants.SelectedView) {
        segueingCell = cell
        detailToShow = detailView
        performSegueWithIdentifier(Constants.Segues.showRonvuDetail, sender: nil)
    }

}




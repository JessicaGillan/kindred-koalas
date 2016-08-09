//
//  RonvuTableViewCell.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/10/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol RonvuTableViewCellDelegate: class {
    func ronvuTableCellRSVPButton(cell: MGSwipeTableCell!, sentRSVP rsvp: Bool) -> Void
    func segueToDetail(fromCell cell: RonvuTableViewCell, toDetail detailView: Constants.SelectedView)
}

class RonvuTableViewCell: MGSwipeTableCell {
    @IBOutlet weak var ronvuProfileImageView: UIImageView!
    @IBOutlet weak var ronvuUserNameLabel: UILabel!
    @IBOutlet weak var ronvuUserHandleLabel: UILabel!
    @IBOutlet weak var ronvuDatePostedLabel: UILabel!
    @IBOutlet weak var ronvuDescriptionTextLabel: UILabel!
    @IBOutlet weak var ronvuNumberOfAttendeesLabel: UILabel!
    @IBOutlet weak var ronvuTimeTilRonvuLabel: UILabel!  
    
    var ronvu: Ronvu? {
        didSet {
            updateUI()
        }
    }
    
    weak var ronvuCellDelegate: RonvuTableViewCellDelegate?
    
    class var expandedHeight: CGFloat { get { return 450 } }
    class var defaultHeight: CGFloat  { get { return 185  } }
    
    private func updateUI() {
        // Reset any existing information
        ronvuProfileImageView?.image = nil
        ronvuUserNameLabel?.text = nil
        ronvuUserHandleLabel?.text = nil
        ronvuDatePostedLabel?.text = nil
        ronvuDescriptionTextLabel?.text = nil
        ronvuNumberOfAttendeesLabel?.text = nil
        ronvuTimeTilRonvuLabel?.text = nil
        
        // Load new information from ronvu (if any)
        if let ronvu = self.ronvu {
            
            ronvuUserNameLabel?.text = ronvu.user.name
            ronvuUserHandleLabel?.text = ronvu.user.handle
            ronvuDescriptionTextLabel?.text = ronvu.text
            
            if let numPeopleGoing = ronvu.numberPeopleGoing {
                if let maxCapacity = ronvu.maxCapacity {
                    ronvuNumberOfAttendeesLabel?.text = "\(maxCapacity - numPeopleGoing) spots left!"
                } else {
                    ronvuNumberOfAttendeesLabel?.text = "\(numPeopleGoing) people going"
                }
            }
            
            // FIXME : Update way to get image data - push to notification center?
            if let profileImageURL = ronvu.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // Blocks main thread! FIX
                    ronvuProfileImageView?.image = UIImage(data: imageData)
                } else {
                    ronvuProfileImageView?.image = UIImage(named: "userHolderImage.png")
                }
            } else {
                ronvuProfileImageView?.image = UIImage(named: "userHolderImage.png")
            }
            
            // FIX : Date/calendar presentation and localization
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(ronvu.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            ronvuDatePostedLabel?.text = formatter.stringFromDate(ronvu.created)

            // FIX : Date/calendar presentation and localization
            if let ronvuDate = ronvu.dateOfRonvu {
                ronvuTimeTilRonvuLabel?.text = "in " + ronvuDate.offsetFrom(NSDate())
            }
        }
        
    }
    
    @IBAction func segueToPartyLine(sender: UIButton) {
        ronvuCellDelegate?.segueToDetail(fromCell: self, toDetail: Constants.SelectedView.PartyLine)
    }
    
    @IBAction func segueToWhenAndWhere(sender: UIButton) {
        ronvuCellDelegate?.segueToDetail(fromCell: self, toDetail: Constants.SelectedView.WhenAndWhere)
    }
    
    @IBAction func sendRSVPYes(sender: UIButton) {
        print("sent rsvp yes to delegate")
        ronvuCellDelegate?.ronvuTableCellRSVPButton(self, sentRSVP: true)
    }
    @IBAction func sendRSVPNo(sender: UIButton) {
        ronvuCellDelegate?.ronvuTableCellRSVPButton(self, sentRSVP: false)
    }
    
    // MARK: - Lifecycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
     */

}

private extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
}

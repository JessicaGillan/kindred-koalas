//
//  RonvuDetailViewController.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/23/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class RonvuDetailViewController: UIViewController, UITextFieldDelegate
{
    struct Segues {
        static let partyLine = "partyLineTableViewSegue"
        static let whenAndWhere = "whenWhereViewSegue"
    }
    
    @IBOutlet weak var partyLineView: UIView!
    @IBOutlet weak var whenAndWhereView: UIView!
    @IBOutlet weak var partyLineButton: UIButton!
    @IBOutlet weak var whenAndWhereButton: UIButton!
    @IBOutlet weak var ronvuTextLabel: UILabel!
    @IBOutlet weak var inviteFriendsButton: UIButton!
    @IBOutlet weak var inviteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inviteButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDarkSeparatorView: UIView!
    @IBOutlet weak var bottomLightSeparatorView: UIView!

    
    var ronvu: Ronvu?    
    var detailToShow: Constants.SelectedView?
    
    @IBOutlet weak var commentTextField: UITextField! {
        didSet {
            commentTextField.delegate = self
        }
    }
    
    @IBAction func showPartyLineDetail(sender: UIButton) {
        showDetailView(forButton: .PartyLine)
    }

    @IBAction func showWhenWhereDetail(sender: UIButton) {
        showDetailView(forButton: .WhenAndWhere)
    }
    
    private func showDetailView(forButton button: Constants.SelectedView) {
        switch button {
        case .PartyLine:
            partyLineView.hidden = false
            whenAndWhereView.hidden = true
            partyLineButton.setTitleColor(Constants.Colors.ronvuTeal, forState: .Normal)
            whenAndWhereButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            commentTextField.hidden = false
            bottomDarkSeparatorView.hidden = false
            bottomLightSeparatorView.hidden = false
        case .WhenAndWhere:
            whenAndWhereView.hidden = false
            partyLineView.hidden = true
            whenAndWhereButton.setTitleColor(Constants.Colors.ronvuTeal, forState: .Normal)
            partyLineButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            commentTextField.hidden = true
            bottomDarkSeparatorView.hidden = true
            bottomLightSeparatorView.hidden = true
        }
    }
    
    func animateWithKeyboard(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let newKeyboardRect = self.view.convertRect(keyboardRect, fromView: nil)
            let keyboardHeight = newKeyboardRect.height
            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
            let options = UIViewAnimationOptions(rawValue: curve << 16)
            
            let moveUp = (notification.name == UIKeyboardWillShowNotification)
            self.view.frame.origin.y = moveUp ? -(keyboardHeight - tabBarHeight) : 0
            
            UIView.animateWithDuration(duration, delay: 0, options: options,
                                       animations: {
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    // MARK: - Text field delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let commentText = textField.text where !commentText.isEmpty {
            if let ronvu = ronvu {
                    Downloader.sharedDownloader.postComment(commentText, onRonvu: ronvu)
            }
        }
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = "+ Jump in"
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = Constants.Colors.ronvuTeal
        
        if let ronvu = ronvu {
            ronvuTextLabel.text = ronvu.text
            if ronvu.friendsCanInviteFriends != nil {
                if ronvu.friendsCanInviteFriends! {
                    setUpInviteButton()
                } else {
                    inviteButtonHeightConstraint.constant = 0 // FIXME: This alone is not working, so hide but there's a gap
                    inviteFriendsButton.hidden = true
                }
            }
        }
        
        // Set Current view and button select
        if let currentButton = detailToShow {
            showDetailView(forButton: currentButton)
        }
        
        // Add observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RonvuDetailViewController.animateWithKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RonvuDetailViewController.animateWithKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        if segue.identifier == Segues.partyLine {
            let vc = segue.destinationViewController as! PartyLineTableViewController
            if let ronvu = ronvu {
                vc.ronvu = ronvu
            }
        } else if segue.identifier == Segues.whenAndWhere {
            let vc = segue.destinationViewController as! WhenAndWhereViewController
            if let ronvu = ronvu {
                vc.ronvu = ronvu
            }
        }
    }
       
    // MARK: Setup
    
    func setUpInviteButton(){
        inviteFriendsButton.backgroundColor = UIColor.clearColor()
        inviteFriendsButton.layer.cornerRadius = 5
        inviteFriendsButton.layer.borderWidth = 1
        inviteFriendsButton.layer.borderColor = Constants.Colors.ronvuCoral.CGColor
        inviteFriendsButton.setTitleColor(Constants.Colors.ronvuCoral, forState: .Normal)
        inviteFriendsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

}

//
//  CommentTableViewCell.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/23/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        // Reset any existing information
        userImageView?.image = nil
        userNameLabel?.text = nil
        userHandleLabel?.text = nil
        commentTextLabel?.text = nil
        
        // Load new information from comment (if any)
        if let comment = self.comment {
            
            userNameLabel?.text = comment.user.name
            userHandleLabel?.text = comment.user.handle
            commentTextLabel?.text = comment.text
            
            // FIXME : Update way to get image data - push to notification center?
            if let profileImageURL = comment.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // Blocks main thread! FIX
                    userImageView?.image = UIImage(data: imageData)
                } else {
                    userImageView?.image = UIImage(named: "userHolderImage.png")
                }
            } else {
                userImageView?.image = UIImage(named: "userHolderImage.png")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

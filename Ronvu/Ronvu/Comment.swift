//
//  Comment.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/23/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation

// container to hold data about a Comment

var testCount: Int = 0

protocol CommentDataPersisting: class {
    func postComment(comment: Comment, result: (Bool)->Void) // FIXME: total guess, change this
}

class Comment: CustomStringConvertible {
    let text: String
    let user: User
    let created: NSDate
    let id: String?
    
    init?(data: NSDictionary?) {
        if let user = User(data: data?.valueForKeyPath(FirebaseKey.User) as? NSDictionary) {
            self.user = user
            if let text = data?.valueForKeyPath(FirebaseKey.Text) as? String {
                self.text = text
                if let created = (data?.valueForKeyPath(FirebaseKey.Created) as? String)?.asRonvuDate {
                    self.created = created
                    id = data?.valueForKeyPath(FirebaseKey.ID) as? String
                    return
                }
            }
        }
        // we've failed
        // CHANGE - what happens when this fails w/non-optionals not set? hm....
        return nil
    }
    
    var description: String { return "\(user) - \(created)\n\(text)\n" + (id == nil ? "" : "\nid: \(id!)") }
    
    // CHANGE - Remove altogether? Should people be able to initiate a ronvu w/o its data??
    init() {
        self.text = "I'm in! lots of words li li liiiiiii lliasdlkfjsa;ldkfjl;skd k oh hey my typing is awful"
        self.user = User()
        self.created = NSDate()
        self.id = "\(testCount)"
        testCount += 1
    }
    
}



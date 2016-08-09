//
//  FirebaseDownloader.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/10/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation

struct Notification {
    static let QueryForRonvusNotification = "queryForRonvusNotification"
    static let RSVPForRonvuNotification = "RSVPForRonvuNotification"
    static let CommentsNotification = "CommentsNotification"
}

class Downloader: NSObject, UserDataPersisting, RonvuDataPersisting
{
    // Singleton - Create only one instance of this class to can keep track of what it is currently doing
    static let sharedDownloader = Downloader()
    
    // CHANGE - compute request to do
    private var firebaseRequest: FirebaseRequest {
        return FirebaseRequest()
    }
    
    // This Only works if we're doing the same request again, 
    // might have to just nix and do full request each time? 
    private var lastFirebaseRequest: FirebaseRequest?
    private var nextRequestToAttempt: FirebaseRequest? {
        if lastFirebaseRequest == nil {
            return firebaseRequest
        } else {
            return lastFirebaseRequest!.requestForNewer
        }
    }
   
    // Query for Ronvus
    //generic and take arguments for local/going/invites? or Maybe better encapsulation to have separate funcs?
    //If have separate funcs, be sure to put all replicated code in functions
    // in here, make an instance of firebase query, execute according to options, post "AnyObject" results in notification
    // make sure that results that come back are still the results the user wants! ie they have not made a new request in the meantime
    func queryForRonvus() {
        
        // CHANGE - update and remove this test code
        if let request = nextRequestToAttempt{
            lastFirebaseRequest = request
            request.fetch { (results) in
                if let results = results {
                    // Post Notification on main queue, where handler will be executed
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName(Notification.QueryForRonvusNotification, object: results)
                    }
                }
            }
        }

    }
    
    // FIXME: - Post RSVP to Firebase for user to ronvu, get back success and error, post norification
    func sendRSVPForRonvu(ronvu: Ronvu, rsvp: Bool) {
        var success = false
        if let id = ronvu.id {
            
            print("RSVP " + (rsvp ? "yes ":"no ") + "recieved for Ronvu ID#: " + id)
            success = true
            
            // Post Notification on main queue, where handler will be executed
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.RSVPForRonvuNotification, object: success)
            }
        }        
    }
    
    // FIXME
    func queryForComments(onRonvu ronvu: Ronvu) {
        let request = FirebaseRequest()
        request.fetchComments(forRonvu: ronvu) { (results) in
            if let results = results {
                // Post Notification on main queue, where handler will be executed
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName(Notification.CommentsNotification, object: results)
                }
            }
        }
    }
    
    // FIXME
    func postComment(commentText: String, onRonvu: Ronvu){
        // Create Firebase comment, set values for keys, save in background with block?
        print(commentText + " received for Ronvu: " + onRonvu.id! ?? "")
        
    }
    
    // MARK: - Protocol Implementation
    
    func createUser(user: User, result: (Bool) -> Void) {
        // Create a user in Firebase
    }
    
    func createRonvu(ronvu: Ronvu, result: (Bool) -> Void) {
        // Create a ronvu in Firebase
    }
    
}

// MARK: - Exensions

// CHANGE extensions to work with Firebase objects
extension User {
    func toFirebaseObject(user: User) -> NSObject? {
        return nil
    }
    
    // CHANGE - this is a guess at how to start orienting data passing w/FB
    struct FirebaseKey {
        static let Name = "name"
        static let Handle = "screen_name"
        static let ID = "id_str"
        static let ProfileImageURL = "profile_image_url"
    }
}

extension Ronvu {
    func toFirebaseObject(ronvu: Ronvu) -> NSObject? {
        return nil
    }
    
    // CHANGE - this is a guess at how to start orienting data passing w/FB
    struct FirebaseKey {
        static let Text = "text"
        static let User = "user"
        static let Created = "date_created"
        static let RonvuAddress = "address"
        static let RonvuLocationTitle = "location"
        static let RonvuDate = "date"
        static let NumGoing = "going"
        static let Capacity = "capacity"
        static let ID = "id_str"
        static let invitesAllowed = "invites_allowed"
    }
}

extension Comment {
    
    // CHANGE - this is a guess at how to start orienting data passing w/FB
    struct FirebaseKey {
        static let Text = "text"
        static let User = "user"
        static let Created = "date_created"
        static let ID = "id_str"
    }
}




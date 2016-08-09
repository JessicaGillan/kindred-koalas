//
//  Ronvu.swift
//  
//
//  Created by Jessica Gillan on 6/10/16.
//
//

import Foundation

// container to hold data about a Ronvu
// FIX : Date/calendar localization

var commentTestCount: Int = 0
var inviteToggle: Bool = true

protocol RonvuDataPersisting: class {
    func createRonvu(ronvu: Ronvu, result: (Bool)->Void)
}

class Ronvu: CustomStringConvertible {
    let text: String
    let user: User
    let created: NSDate
    let friendsCanInviteFriends: Bool? // FIXME: Make non-optional?
    let locationTitle: String
    let locationAddress: String? // CHANGE : how to handle addresses? --> REMOVE, use only title and coordinates?
    let locationLat: Double?
    let locationLong: Double?
    let dateOfRonvu: NSDate?
    let numberPeopleGoing: Int?
    let maxCapacity: Int?
    let id: String?
    
    init?(data: NSDictionary?) {
        if let user = User(data: data?.valueForKeyPath(FirebaseKey.User) as? NSDictionary) {
            self.user = user
            if let text = data?.valueForKeyPath(FirebaseKey.Text) as? String {
                self.text = text
                if let created = (data?.valueForKeyPath(FirebaseKey.Created) as? String)?.asRonvuDate {
                    self.created = created
                    if let locationTitle = data?.valueForKeyPath(FirebaseKey.RonvuLocationTitle) as? String {
                        self.locationTitle = locationTitle
                        locationAddress = data?.valueForKey(FirebaseKey.RonvuAddress) as? String
                        locationLat = 0.0 // FIXME
                        locationLong = 0.0 // FIXME
                        dateOfRonvu = (data?.valueForKey(FirebaseKey.RonvuDate) as? String)?.asRonvuDate
                        numberPeopleGoing = data?.valueForKey(FirebaseKey.NumGoing) as? Int
                        maxCapacity = data?.valueForKey(FirebaseKey.Capacity) as? Int
                        id = data?.valueForKeyPath(FirebaseKey.ID) as? String
                        friendsCanInviteFriends = data?.valueForKeyPath(FirebaseKey.invitesAllowed) as? Bool
                        return
                    }
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
        self.text = "Who's down for a rooftop kickback blah blah blah blah blah blllllaaaaahhhhhhhh?"
        self.user = User()
        self.created = NSDate()
        self.locationTitle = "Bob's House"
        self.locationAddress = "356 Bird St, denver co 80221"
        self.locationLat = nil
        self.locationLong = nil
        self.dateOfRonvu = NSDate(timeIntervalSinceNow: 60*60*24*16 ) // CHANGE :  16 days away in seconds
        self.numberPeopleGoing = testCount
        self.maxCapacity = 20
        self.id = "\(commentTestCount)"
        self.friendsCanInviteFriends = inviteToggle
        inviteToggle = !inviteToggle
        commentTestCount += 1
    }
    
}

// FIXME: - is this the format for dates From FB?
extension String {
    var asRonvuDate: NSDate? {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            return dateFormatter.dateFromString(self)
        }
    }
}

// FIXME: - this is ugly format, fix it to custom format?
extension NSDate {
    var asRonvuString: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            return dateFormatter.stringFromDate(self)
        }
    }
}


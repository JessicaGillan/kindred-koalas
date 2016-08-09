//
//  User.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/10/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation

// container to hold data about a Ronvu

protocol UserDataPersisting: class {
    func createUser(user: User, result: (Bool)->Void)
}

struct User: CustomStringConvertible {
    let handle: String
    let name: String?
    let id: String?
    let profileImageURL: NSURL?
    
    init?(data: NSDictionary?) {
        if let handle = data?.valueForKeyPath(FirebaseKey.Handle) as? String {
            self.handle = handle
            self.name = data?.valueForKey(FirebaseKey.Name) as? String
            self.id = data?.valueForKeyPath(FirebaseKey.ID) as? String
            if let urlString = data?.valueForKeyPath(FirebaseKey.ProfileImageURL) as? String {
                self.profileImageURL = NSURL(string: urlString)
            } else {
                profileImageURL = nil
            }
        } else {
            return nil
        }
    }
    
    var description: String { return "\(name) - \(handle)\n" + (id == nil ? "" : "\nid: \(id!)") + (profileImageURL == nil ? "": "\nimageURL: \(profileImageURL!)")}
    
    var asPropertyList: AnyObject {
        var dictionary = Dictionary<String,String>()
        dictionary[FirebaseKey.Name] = self.name
        dictionary[FirebaseKey.Handle] = self.handle
        dictionary[FirebaseKey.ID] = self.id
        dictionary[FirebaseKey.ProfileImageURL] = profileImageURL?.absoluteString
        return dictionary
    }
    
    // FIXME
    init(){
        self.handle = "@PartyPigeon" // CHANGE - these probs need to be IndexedKeyword type, see Smashtag/Twitter/Tweet
        self.name = "Paco"
        self.id = nil
        self.profileImageURL = nil
    }  

}


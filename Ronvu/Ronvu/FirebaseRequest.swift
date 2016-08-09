//
//  FirebaseRequest.swift
//  Ronvu
//
//  Created by Jessica Gillan on 6/15/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation
import Accounts
import Social
import CoreLocation

// ********* Model After smashtag example ******************************//
// Simple Twitter query class
// Create an instance of it using one of the initializers
// Set the requestType and parameters (if not using a convenience init that sets those)
// Call fetch (or fetchTweets if fetching Tweets)
// The handler passed in will be called when the information comes back from Twitter
// Once a successful fetch has happened,
//   a follow-on TwitterRequest to get more Tweets (newer or older) can be created
//   using the requestFor{Newer,Older} methods

private var ronvuAccount: ACAccount?

class FirebaseRequest
{
//    public let requestType: String
//    public let parameters = Dictionary<String, String>()
//    
//    // designated initializer
//    public init(_ requestType: String, _ parameters: Dictionary<String, String> = [:]) {
//        self.requestType = requestType
//        self.parameters = parameters
//    }
//    
//    // convenience initializer for creating a TwitterRequest that is a search for Tweets
//    public convenience init(search: String, count: Int = 0, _ resultType: SearchResultType = .Mixed, _ region: CLCircularRegion? = nil) {
//        var parameters = [TwitterKey.Query : search]
//        if count > 0 {
//            parameters[TwitterKey.Count] = "\(count)"
//        }
//        switch resultType {
//        case .Recent: parameters[TwitterKey.ResultType] = TwitterKey.ResultTypeRecent
//        case .Popular: parameters[TwitterKey.ResultType] = TwitterKey.ResultTypePopular
//        default: break
//        }
//        if let geocode = region {
//            parameters[TwitterKey.Geocode] = "\(geocode.center.latitude),\(geocode.center.longitude),\(geocode.radius/1000.0)km"
//        }
//        self.init(TwitterKey.SearchForTweets, parameters)
//    }
//    
//    public enum SearchResultType {
//        case Mixed
//        case Recent
//        case Popular
//    }
    
    // convenience "fetch" for when self is a request that returns Tweet(s)
    // handler is not necessarily invoked on the main queue
    
//    func fetchRonvus(handler: ([Ronvu]) -> Void) {
//        fetch { results in
//            var tweets = [Tweet]()
//            var tweetArray: NSArray?
//            if let dictionary = results as? NSDictionary {
//                if let tweets = dictionary[TwitterKey.Tweets] as? NSArray {
//                    tweetArray = tweets
//                } else if let tweet = Tweet(data: dictionary) {
//                    tweets = [tweet]
//                }
//            } else if let array = results as? NSArray {
//                tweetArray = array
//            }
//            if tweetArray != nil {
//                for tweetData in tweetArray! {
//                    if let tweet = Tweet(data: tweetData as? NSDictionary) {
//                        tweets.append(tweet)
//                    }
//                }
//            }
//            handler(tweets)
//        }
//    }
    
    var requestForNewer: FirebaseRequest? {
        // CHANGE - Make a request just for newer results? So don't reload all data
        return FirebaseRequest()
    }
    
    typealias PropertyList = AnyObject
    
    // send an arbitrary request off to Firebase
    // calls the handler (not necessarily on the main queue)
    //   with the JSON results converted to a Property List
    
    func fetch(handler: (results: PropertyList?) -> Void) {
        //performFirebaseRequest ...
        handler( results: [Ronvu(),Ronvu(),Ronvu(),Ronvu(),Ronvu(),Ronvu(),Ronvu()] as PropertyList )
    }
    
    func fetchComments(forRonvu ronvu: Ronvu, handler: (results: PropertyList?) -> Void) {
        handler(results: [Comment(), Comment(),Comment(),Comment(),Comment(),Comment()])
    }


}





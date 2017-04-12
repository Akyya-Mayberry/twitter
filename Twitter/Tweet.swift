//
//  Tweet.swift
//  Twitter
//
//  Created by hollywoodno on 4/12/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var text: String?
  var timestamp: Date?
  var retweetCount: Int = 0
  var favoritesCount: Int = 0

  init(dictionary: NSDictionary){
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
    
    // If a date is retrieved in dict, parse it
    if let timeStampString = dictionary["created_at"] {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timeStampString as! String)
    }
  }
  
  // Generates and returns list of tweets as array of tweet object instead of dictionaries
  // Because it is a class function, it can be used without an instance of a Tweet.
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in dictionaries {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}

//
//  Tweet.swift
//  Twitter
//
//  Created by hollywoodno on 4/12/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var id: Int? // Twitter has a string representation of this, may want to update to string val
  var user: NSDictionary?
  var text: String?
  var timestamp: Date?
  var favorited: Bool?
  var retweeted: Bool?
  var retweetCount: Int = 0
  var favoritesCount: Int = 0
  
  init(dictionary: NSDictionary){
    id = dictionary["id"] as? Int
    user = dictionary["user"] as? NSDictionary
    text = dictionary["text"] as? String
    retweeted = dictionary["retweeted"] as? Bool
    favorited = dictionary["favorited"] as? Bool
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    
    // Not sure twitter includes favorites count anymore
    // Favourites_count is listed under the user key.
    favoritesCount = self.user?["favorite_count"] as? Int ?? 0
    
    
    
    // If a date is retrieved in dict, parse it
    if let timeStampString = dictionary["created_at"] {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timeStampString as! String)
    }
  }
  
  // Generates and returns list of tweets as array of tweet objects instead of dictionaries.
  // Because it is a class function, it can be used without an instance of a Tweet.
  // Ex. Tweet.tweetsWithArray(dictionaries: someDict)
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in dictionaries {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}

//
//  User.swift
//  Twitter
//
//  Created by hollywoodno on 4/12/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class User: NSObject {
  var name: String?
  var screenname: String?
  var profileUrl: URL?
  var tagline: String?
  var dictionary: NSDictionary?
  
  init(dictionary: NSDictionary){
    self.dictionary = dictionary
    name = dictionary["name"] as? String
    screenname = dictionary["screen_name"] as? String
    
    if let profileUrlString = dictionary["profile_image_url_https"] as? String {
      profileUrl = URL(string: profileUrlString)
    }
    
    tagline = dictionary["description"] as? String
  }
  
  static var _currentUser: User? // Current logged in user
  static let userDidLogoutNotification = "UserDidLogout"
  
  // Allow the current logged-in user to be accessed anywhere in the app.
  // If it is nil, no user is logged in.
  class var currentUser: User? {
    get {
      // When this property is accessed, this getter provides what is returned.
      // Ex. use - User.currentUser
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.data(forKey: "currentUserData")
        
        if userData != nil {
          // JSON data -> JSON object
          let dictionary = try! JSONSerialization.jsonObject(with: userData!, options: [])
          
          // JSON object -> dictionary
          _currentUser = User(dictionary: dictionary as! NSDictionary)
        }
      }
      return _currentUser
    }
    
    // This code is executed when currentUser is assigned
    // Ex. User.currentUser = ...
    set(user) {
      _currentUser = user
      let defaults = UserDefaults.standard
      
      if let user = user {
        // JSON object -> JSON data
        let userData = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.setValue(userData, forKey: "currentUserData")
      } else {
        defaults.setValue(nil, forKey: "currentUserData")
      }
    }
  }
}

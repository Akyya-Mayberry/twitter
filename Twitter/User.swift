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
  
  init(dictionary: NSDictionary){
    name = dictionary["name"] as? String
    screenname = dictionary["screen_name"] as? String
    
    if let profileUrlString = dictionary["profile_image_url_https"] as? String {
      profileUrl = URL(string: profileUrlString)
    }
    
    tagline = dictionary["description"] as? String
  }
}

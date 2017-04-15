//
//  TwitterClient.swift
//  Twitter
//
//  Created by hollywoodno on 4/12/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
  
  // TwitterClient.sharedInstance allows an instance of BDBOAuth1SessionManager
  // to be shared between view controllers throughout the app.
  // Because it is static no instance of TwitterClient is required
  // Ex. use - TwitterClient.sharedInstance.login()
  
  static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "", consumerSecret: "")
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    deauthorize()
    // In this method, the callback is the callback 'twitterdemo:' a type of web-like application protocol.
    fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
      
      // After getting a token, get authorization to request user to grant access.
      if requestToken != nil {
        if let token = requestToken!.token {
          let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
          
          // Go to Twitter authorization url
          UIApplication.shared.open(url!, options: [:], completionHandler: { (success: Bool) in
            if success {
              //              print("Could access Twitter authorization url.")
            } else {
              //              print("Could not access Twitter authorization url")
            }
          })
        }
      }
    }, failure: { (error: Error?) in
      print("Error getting request token, \(error)")
      self.loginFailure?(error!)
    })
    
  }
  
  func logout() {
    User.currentUser = nil
    
    deauthorize() // Removes access token?
    
    // Set a notification for sending out signal when user logs out.
    let notification = Notification.init(name: Notification.Name(rawValue: User.userDidLogoutNotification))
    NotificationCenter.default.post(name: notification.name, object: nil)
  }
  
  func handleOpenUrl(url: URL){
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    // Receiving an access token will allow this app to make requests to twitter on the behalf of the user
    fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      
      self.userAccount(success: { (user: User) in
        User.currentUser = user
        self.loginSuccess?()
      }, failure: { (error: Error) in
        self.loginFailure?(error)
      })
      
    }) { (error: Error?) -> Void in
      self.loginFailure?(error!)
      print("Error getting access token, \(error)")
    }
  }
  
  func userAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    // Access users account info
    get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: { (nil) in
      print("Progress...")
      
    }, success: { (task: URLSessionDataTask, response: Any?) in
      let user = User(dictionary: response as! NSDictionary)
      
      success(user)
      print("Twitter user, '\(user.name!)', account information received!")
      
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error occured retrieving user Twitter acount nformation, \(error)")
      failure(error)
    })
  }
  
  func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    // User twitter feed
    get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: ["count": 20],
        progress: { (nil) in
          print("Progress...")
    },
        success: { (task: URLSessionDataTask, response: Any?) -> Void in
          let tweetsAsDicts = response as! [NSDictionary]
          
          // Take the array of dicts and convert it to a array of Tweet objects.
          // Because tweetsWithArray is class method, I can use the method without an istance.
          let tweets = Tweet.tweetsWithArray(dictionaries: tweetsAsDicts)
          success(tweets)
    },
        failure: { (task: URLSessionDataTask?, error: Error) -> Void in
          failure(error)
    })
  }
  
  
  
  func send(tweet: String, success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()) {
    
    post("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status": tweet], progress: { (nil) in
      print("Progress...")
    }, success: { (task: URLSessionDataTask, response: Any?) in
      print("Tweet sent")
      success(true)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("Error occured posting tweet: \(error)")
    })
  }
  
  func updateFavoritedWith(id: Int, to favorited: Bool, success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()) {
    
    // Distinguish which endpoint to hit
    if favorited {
      post("https://api.twitter.com/1.1/favorites/destroy.json", parameters: ["id": id], progress: { (nil) in
        print("Progress...")
      }, success: { (task: URLSessionDataTask, response: Any?) in
        let response = response as! NSDictionary
        let isFavorited = response["favorited"] as! Bool
        success(isFavorited)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        print("Error updating tweet: \(error)")
        failure(error)
      })
    } else {
      
      // change it to true
      post("https://api.twitter.com/1.1/favorites/create.json", parameters: ["id": id], progress: { (nil) in
        print("Progress...")
      }, success: { (task: URLSessionDataTask, response: Any?) in
        let isFavorited = response as! Bool
        success(isFavorited)
        //        self.tableView.reloadData()
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
      })
    }
  }
  
}

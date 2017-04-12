//
//  AppDelegate.swift
//  Twitter
//
//  Created by hollywoodno on 4/11/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    
    // Request access token
    // This request requires consumer key, consumer secret and request token
    let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "XXXXXXXXXX", consumerSecret: "XXXXXXXXXX")
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    // Receiving an access token will allow this app to make requests to twitter on the behalf of the user
    twitterClient?.fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
      print("Access token received!")
      
      // Access users account info
      twitterClient?.get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: { (nil) in
        print("Progress...")
      }, success: { (task: URLSessionDataTask, response: Any?) in
        let user = User(dictionary: response as! NSDictionary)
        
        
        print("Twitter user, '\(user.name!)', account information received!")
      }, failure: { (task: URLSessionDataTask?, error: Error?) in
        print("Error occured retrieving user Twitter acount nformation, \(error)")
      })
      
      // User tweets
      twitterClient?.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: nil, progress: { (nil) in
        print("Progress...")
      }, success: { (task: URLSessionDataTask, response: Any?) in
        let tweetsAsDicts = response as! [NSDictionary]
        
        // Take the array of dicts and convert it to a array of Tweet objects.
        // Because tweetsWithArray is class method, I can use the method without an istance.
        let tweetsAsArray = Tweet.tweetsWithArray(dictionaries: tweetsAsDicts)
        
        for tweet in tweetsAsArray {
          print(tweet.text!)
        }
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        print("Error occurred while retrieving tweets, \(error)")
      })
      
    }, failure: { (error: Error?) in
      print("Error getting access token, \(error)")
    })
    
    return true
  }


}


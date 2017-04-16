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
    
    // Current logged in users are redirected to their feed.
    if User.currentUser != nil {
      
      // Get the main storyboard and set its root view controller to the tweets view controller.
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
      
      //The window is what is what view currently display in the screen.
      window?.rootViewController = vc
    }
    
    // Listen for when a user logs out so they are redirected login screen.
    NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: User.userDidLogoutNotification), object: nil, queue: OperationQueue.main) { (Notification) in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateInitialViewController()
      self.window?.rootViewController = vc
    }
    
    // Set up shared navigation bar settings
    let navigationBarAppearace = UINavigationBar.appearance()
    navigationBarAppearace.tintColor = UIColor.white // Text buttons
    navigationBarAppearace.barTintColor = UIColor(red: 153/255, green: 206/255, blue: 255/255, alpha: 1) // Nav bar
    navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]  // Title's text color etc.
    
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
    
    // External interaction with Twitter redirects users back to the app here.
    // The handling of what to do is passed to Twitter client.
    TwitterClient.sharedInstance?.handleOpenUrl(url: url)
    
    return true
  }
}


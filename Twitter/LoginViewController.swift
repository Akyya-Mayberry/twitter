//
//  LoginViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/11/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  // Log user in using Twitter Oauth
  @IBAction func onLogin(_ sender: Any) {
    
    // Initiate Oauth by providing app info
    let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "XXXXXXXXXX", consumerSecret: "XXXXXXXXXX")
    
    twitterClient?.deauthorize()
    // in this method, the callback is the callback 'twitterdemo:' a type of web-like application protocol?
    twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
//      print("I got a success token")
      
      // After getting token get authorization to request user to grant access to their account
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
    })
    
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

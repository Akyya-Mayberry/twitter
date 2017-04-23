//
//  ProfileViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/21/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  
  var user: User?
  var userTweets: [Tweet] = []
  var tweet: Tweet? // Only set if current user clicked on profile pic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Absence of a tweet means the user is selecting show profile from side menu,
    // therefore their profile should be displayed
    if tweet == nil {
      self.user = User.currentUser
    }
    
    // From the tweet current user clicked, get the tweeter
    if tweet != nil {
      self.user = User(dictionary: (tweet?.user)!)
    }
    
    nameLabel.text = user?.name!
    handleLabel.text = user?.screenname!
    let following = (user?.following)! as Int
    let followers = (user?.followers)! as Int
    followingCountLabel.text = String(describing: following)
    followersCountLabel.text = String(describing: followers)
    
    if user?.profileUrl != nil {
      userImageView.setImageWith((user?.profileUrl)!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
    } else {
      userImageView.image = #imageLiteral(resourceName: "twitterLogo")
    }
    
    // Get the users timeline
    TwitterClient.sharedInstance?.getUserTimeLine(for: (user?.id)!, success: { (tweets: [Tweet]) in
      self.userTweets = tweets
      print("HERE are users tweets, \(self.userTweets)")
    }, failure: { (error: Error) in
      print("Error retrieving user timeline data")
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
  var user: User?
  var userTweets: [Tweet] = []
  var tweet: Tweet? // Only set if current user clicked on profile pic
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    
    // Absence of a tweet means the user is selecting show profile from side menu,
    // therefore their profile should be displayed
    if tweet == nil {
      self.user = User.currentUser
    }
    
    // From the tweet current user clicked, get the tweeter
    if tweet != nil {
      self.user = User(dictionary: (tweet?.user)!)
    }
    
    // Set up user basic profile section
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
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("Error retrieving user timeline data")
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userTweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
    
    cell.tweet = userTweets[indexPath.row]
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: NAVIGATION
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detailsSegue" {
      let detailsVC = segue.destination as! DetailsTableViewController
      let indexPath = tableView.indexPath(for: sender as! ProfileCell)
      
      detailsVC.tweet = tweet
      detailsVC.indexPath = indexPath
      detailsVC.tweets = userTweets
    }
    
    if segue.identifier == "replySegue" {
      let navigationController = segue.destination as! UINavigationController
      let replyVC = navigationController.topViewController as! ReplyViewController
      
      replyVC.tweets = userTweets
      replyVC.tweet = tweet
    }
    
  }
  
}

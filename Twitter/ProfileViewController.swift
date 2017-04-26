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
  @IBOutlet weak var pageControl: UIPageControl!
  
  //  @IBOutlet weak var nameLabel: UILabel!
  //  @IBOutlet weak var handleLabel: UILabel!
  //  @IBOutlet weak var followersCountLabel: UILabel!
  //  @IBOutlet weak var followingCountLabel: UILabel!
  //  @IBOutlet weak var userImageView: UIImageView!
  //  @IBOutlet weak var tweetsCountLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var PagingContentView: UIView! // Page through profile header views
  
  var user: User?
  var userTweets: [Tweet] = []
  var tweet: Tweet? // Only set if current user clicked on profile pic
  
  // Set's the controller that will manage the content view
  var contentViewController: UIViewController! {
    didSet(oldContentViewController) {
      // Remove any previous view controller
      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }
      
      view.layoutIfNeeded()
      
      // Prep new view controller
      contentViewController.willMove(toParentViewController: self)
      contentViewController.view.frame = CGRect(x: 0, y: 0, width: PagingContentView.frame.size.width, height: PagingContentView.frame.size.height)
      PagingContentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)
      // Close the menu
      UIView.animate(withDuration: 0.3) {
        //        self.contentViewLeftMargin.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up table
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    
    // MARK: PROFILE HEADER SECTION
    
    // Set the paging view controller as controller for header container
    let pagingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
    contentViewController = pagingVC
    
    // Absence of a tweet means the user is selecting show profile from side menu,
    // therefore their profile should be displayed
    if tweet == nil {
      self.user = User.currentUser
    }
    
    // From the tweet current user clicked, get the tweeter
    if tweet != nil {
      if tweet?.retweetedStatus == nil {
        user = User(dictionary: (tweet?.user)!)
      } else {
        let originalUser = tweet?.retweetedStatus?["user"] as? NSDictionary
        user = User(dictionary: originalUser!)
      }
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
      
      detailsVC.tweet = userTweets[(indexPath?.row)!]
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

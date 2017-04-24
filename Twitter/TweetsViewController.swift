//
//  TweetsViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/13/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import MBProgressHUD


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]?
  var isLoadingMoreData = false
  var oldestTweetID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Retrieve user's twitter feed
    MBProgressHUD.showAdded(to: view, animated: true)
    
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: oldestTweetID, success: { (tweets: [Tweet]) in
      
      MBProgressHUD.hide(for: self.view, animated: true)
      self.tweets = tweets
      self.oldestTweetID = (self.tweets?.last)?.id
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("Error retrieving tweets: \(error)")
    })
    
    // Setup refresh control
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshTweetsControl(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return tweets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
    cell.tweet = tweets?[indexPath.row]
    cell.delegate = self
    
    return cell
  }
  
  // MARK: UPDATE DATA
  
  // Refresh data
  func refreshTweetsControl(_ refreshControl: UIRefreshControl) {
    // Fetch data
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: nil, success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.oldestTweetID = (self.tweets?.last)?.id
      self.tableView.reloadData()
      refreshControl.endRefreshing()
    }, failure: { (error: Error) in
      print("Error retrieving tweets: \(error.localizedDescription)")
    })
  }
  
  // Loads more data. If given id of last tweet,
  // it returns tweets before that tweet.
  func loadMoreData() {
    
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: oldestTweetID, success: { (response: [Tweet]) in
      self.tweets?.append(contentsOf: response)
      self.oldestTweetID = (self.tweets?.last)?.id
      self.tableView.reloadData()
      self.isLoadingMoreData = false
    }, failure: { (error: Error) in
      print("Error occurred loading more data, error: \(error.localizedDescription)")
    })
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !(isLoadingMoreData) {
      // Check whether more data should be fetch
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollViewThreshold = scrollViewContentHeight - tableView.bounds.size.height // the length of table view shown
      let scrollThreshold = tableView.contentOffset.y > scrollViewThreshold
      
      if scrollView.isDragging && scrollThreshold {
        isLoadingMoreData = true
        loadMoreData()
      }
    }
  }
  
  // MARK: USER INTERACTIONS
  
  // View a users profile page
  func TweetCell(tweetCell: TweetCell, didTap value: Bool) {
    let indexPath = tableView.indexPath(for: tweetCell)
    let tweet = tweets?[(indexPath?.row)!]
    
    // Display profile view of owner of the tweet
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let profileVC = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    profileVC.tweet = tweet!
    
    show(profileVC, sender: self)
  }
  
  // Reverses the state of a retweet.
  // Updates the tweet object and button to reflect the change.
  @IBAction func onRetweet(_ sender: Any) {
    let sender = sender as! UIButton
    let cell = sender.superview?.superview as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    let tweet = tweets?[(indexPath?.row)!]
    let id = tweet?.id!
    let retweeted = tweet?.retweeted!
    
    
    TwitterClient.sharedInstance?.updateRetweetStatus(id: id!, to: retweeted!, success: { (response: Bool) in
      tweet?.retweeted = response
      
      if response {
        sender.setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
      } else {
        sender.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
      }
    }, failure: { (error: Error) in
      print("Issue retweeting, error: \(error)")
    })
  }
  
  // Reverses the state of a favorited value of a tweet.
  // Updates the tweet object and button to reflect the change.
  @IBAction func toggleFav(_ sender: Any) {
    
    let sender = sender as! UIButton
    let cell = sender.superview?.superview as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    let tweet = tweets?[(indexPath?.row)!]
    let favorited = tweet?.favorited!
    let id = tweet?.id!
    
    TwitterClient.sharedInstance?.updateFavoritedWith(id: id!, to: favorited!, success: { (response: Bool) in
      tweet?.favorited = response
      if response {
        sender.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        sender.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
    }, failure: { (error: Error) in
      print("Error updating favorited status: \(error.localizedDescription)")
    })
  }
  
  @IBAction func onLogout(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
  
  
  // MARK: NAVIGATION
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detailsSegue" {
      let detailsVC = segue.destination as! DetailsTableViewController
      let indexPath = tableView.indexPath(for: sender as! TweetCell)
      
      detailsVC.tweet = tweets?[(indexPath?.row)!]
      detailsVC.indexPath = indexPath
      detailsVC.tweets = tweets
      detailsVC.sender = sender as! TweetCell?
    }
    
    if segue.identifier == "replySegue" {
      let navigationController = segue.destination as! UINavigationController
      let replyVC = navigationController.topViewController as! ReplyViewController
      
      // Get the cell associated with the button that was clicked
      let sender = sender as! UIButton
      let cell = sender.superview?.superview as! UITableViewCell
      let indexPath = tableView.indexPath(for: cell)
      
      replyVC.tweets = tweets
      replyVC.tweet = tweets?[(indexPath?.row)!]
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

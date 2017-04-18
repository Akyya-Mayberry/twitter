//
//  TweetsViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/13/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]?
  var isLoadingMoreData = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Retrieve user's twitter feed
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: nil, success: { (tweets: [Tweet]) in
      self.tweets = tweets
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
    
    return cell
  }
  
  // Refresh data
  func refreshTweetsControl(_ refreshControl: UIRefreshControl) {
    // Fetch data
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: nil, success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      refreshControl.endRefreshing()
    }, failure: { (error: Error) in
      print("Error retrieving tweets: \(error)")
    })
  }
  
  // Loads more data. If given id of last tweet,
  // it returns tweets before that tweet.
  func loadMoreDataAfter(lastTweetID id: Int?) {
    // track view did scroll.
    // when its time to load more data
    // get the id of the last item in tweets, and
    // call client get method to retrieve tweets before it
    
    TwitterClient.sharedInstance?.homeTimeLine(tweetsBeforeID: id, success: { (response: [Tweet]) in
//      print("######## Last 10 tweets, \(response)")
      self.isLoadingMoreData = false
      self.tweets?.append(contentsOf: response)
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("Error occurred loading more data, error: \(error.localizedDescription)")
    })
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("scoll occurred!")
    
    if !(isLoadingMoreData) {
      
      // Check whether more data should be fetch
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollViewThreshold = scrollViewContentHeight - tableView.bounds.size.height // the length of table view shown
      
      // Threshold is met if top left corner of table view is further down in the , then the maxHeightToReach
      let scrollThreshold = tableView.contentOffset.y > scrollViewThreshold
      
      if scrollView.isDragging && scrollThreshold {
        print("Load more data")
        let lastTweet = tweets?.last
        print("HERE IS THAT LAST TWEET ID, \(lastTweet?.id)")
        loadMoreDataAfter(lastTweetID: (lastTweet)!.id)
      }
      
    }
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detailsSegue" {
      let detailsVC = segue.destination as! TweetDetailsViewController
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

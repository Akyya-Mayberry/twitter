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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Retrieve user's twitter feed
    TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
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
    TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      refreshControl.endRefreshing()
    }, failure: { (error: Error) in
      print("Error retrieving tweets: \(error)")
    })
  }
  
  @IBAction func toggleFav(_ sender: Any) {
    // Reverses the state of a favorited value of a tweet.
    // Updates the tweet object and button to reflect the change.
    
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

//
//  MentionsViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/22/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MentionsCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    
    
    // Network call to get mentions tweets
    TwitterClient.sharedInstance?.getUserMentions(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
      print("SUCCESSFULLY GOT MENTIONS")
    }, failure: { (error: Error) in
      print("Error getting mentions, error: \(error)")
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return tweets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell") as! MentionsCell
    
    cell.tweet = tweets?[indexPath.row]
    cell.delegate = self
    
    return cell
  }
  
  
  // MARK: USER INTERACTIONS
  
  func MentionsCell(mentionsCell: MentionsCell, didTap value: Bool) {
    let indexPath = tableView.indexPath(for: mentionsCell)
    let tweet = tweets?[(indexPath?.row)!]
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let profileVC = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    
    profileVC.tweet = tweet
    show(profileVC, sender: self)
    
  }
  
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

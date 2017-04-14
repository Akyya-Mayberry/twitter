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
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 330
    tableView.rowHeight = UITableViewAutomaticDimension
    
    TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("Error retrieving tweets: \(error)")
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return tweets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
    cell.tweet = tweets?[indexPath.row]
    
    return cell
  }
  
  @IBAction func onLogout(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

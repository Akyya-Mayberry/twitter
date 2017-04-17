//
//  ReplyViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/16/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class ReplyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweet: Tweet?
  var tweets: [Tweet]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    
    tableView.register(UINib(nibName: "ReplyCell", bundle: nil), forCellReuseIdentifier: "replyCell")
    tableView.register(UINib(nibName: "CountCell", bundle: nil), forCellReuseIdentifier: "countCell")
    tableView.register(UINib(nibName: "ReactionsCell", bundle: nil), forCellReuseIdentifier: "reactionsCell")
    tableView.register(UINib(nibName: "ComposeCell", bundle: nil), forCellReuseIdentifier: "composeCell")
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell") as! ReplyCell
    cell.tweet = tweet
    return cell
  }
  
  @IBAction func onCancel(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func onSend(_ sender: Any) {
    let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
    let tweet = tweets?[(indexPath?.row)!]
    let cell = tableView.cellForRow(at: indexPath!) as! ReplyCell
    let composeText = cell.composeText.text!
    let id = tweet?.in_reply_to_user_id
    
    TwitterClient.sharedInstance?.sendReplyTo(tweet: id!, with: composeText, success: { (response: Bool) in
      print("Reply sent, response is: \(response)")
      self.dismiss(animated: true)
    }, failure: { (error: Error) in
      print("Error posting reply: error: \(error)")
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

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
    
    if tweet != nil {
      cell.tweet = tweet!
    }
    
    return cell
  }
  
  @IBAction func onCancel(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func onSend(_ sender: Any) {
    let indexPath = IndexPath(row: 0, section: 0)
    let tweet = tweets?[(indexPath.row)]
    let cell = tableView.cellForRow(at: indexPath) as! ReplyCell
    let composeText = "@\(tweet?.user?["screen_name"] as! String) \(cell.composeText.text!)"
    let id = tweet?.id
    
    TwitterClient.sharedInstance?.sendReplyTo(tweet: id!, with: composeText, success: { (response: Any?) in
      if response != nil {
        self.dismiss(animated: true)
      }
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

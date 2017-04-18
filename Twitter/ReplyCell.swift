//
//  ReplyCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/16/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class ReplyCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var originalTweeterNameLabel: UILabel!
  @IBOutlet weak var originalTweeterImageView: UIImageView!
  @IBOutlet weak var originalTweeterHandleLabel: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var composeText: UITextView!
  @IBOutlet weak var retweetImageView: UIImageView!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      composeText.sizeToFit()
      
      // Tweet original or retweet
      if tweet?.retweetedStatus != nil {
        nameLabel.isHidden = false
        retweetImageView.isHidden = false
        nameLabel.text = "\(tweet?.user?["screen_name"] as! String) retweeted"
        originalTweeterNameLabel.text = tweet?.retweetOriginalUser?["name"] as! String?
        originalTweeterHandleLabel.text = "@\(tweet?.retweetOriginalUser?["screen_name"] as! String)"
        let imagePath = tweet?.retweetOriginalUser?["profile_image_url_https"] as? String
        
        if imagePath != nil && !((imagePath?.isEmpty)!) {
          let imageURL = URL(string: imagePath!)
          originalTweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
        } else {
          originalTweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
        }
        
      } else {
        originalTweeterNameLabel.text = tweet?.user?["name"] as! String?
        originalTweeterHandleLabel.text = "@\(tweet?.user?["screen_name"] as! String)"
        
        let imagePath = tweet?.user?["profile_image_url_https"] as? String
        
        if imagePath != nil && !((imagePath?.isEmpty)!) {
          let imageURL = URL(string: imagePath!)
          originalTweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
        } else {
          originalTweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
        }
        
      }
      
      originalTweeterImageView.layer.cornerRadius = 10
      originalTweeterImageView.clipsToBounds = true
      originalTweeterImageView.layer.borderWidth = 3
      
      // Time lapse/date for Tweet Post
      //      let formatter = DateFormatter()
      //      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      //      let timestamp = tweet?.timestamp
      //      let now = Date()
      //      let timePassed = now.timeIntervalSince(timestamp!)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    composeText.becomeFirstResponder()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func onSend(_ sender: Any) {
    let id = tweet?.in_reply_to_user_id
    TwitterClient.sharedInstance?.sendReplyTo(tweet: id!, with: "\(originalTweeterHandleLabel.text)\(composeText.text)", success: { (response: Any?) in
    }, failure: { (error: Error) in
      print("####Error sending reply: error: \(error)")
    })
  }
}

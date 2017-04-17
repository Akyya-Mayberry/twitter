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
  @IBOutlet weak var retweeterImageView: UIImageView!
  @IBOutlet weak var tweeterImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var retweeterNameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var composeText: UITextView!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      composeText.sizeToFit()
      nameLabel.text = tweet?.user?["name"] as? String
      handleLabel.text = "@ \(tweet?.user?["screen_name"] as? String)!"
      
      let imagePath = tweet?.user?["profile_image_url_https"] as? String
      
      if imagePath != nil && !((imagePath?.isEmpty)!) {
        let imageURL = URL(string: imagePath!)
        tweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
      } else {
        tweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
      }
      
      tweeterImageView.layer.cornerRadius = 10
      tweeterImageView.clipsToBounds = true
      tweeterImageView.layer.borderWidth = 3
      
      // Time lapse/date for Tweet Post
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      let timestamp = tweet?.timestamp
      let now = Date()
      let timePassed = now.timeIntervalSince(timestamp!)
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
    print("#########send button touch!")
    let id = tweet?.in_reply_to_user_id
    TwitterClient.sharedInstance?.sendReplyTo(tweet: id!, with: composeText.text, success: { (response: Any?) in
      print("####Reply successfully sent, response: \(response)")
    }, failure: { (error: Error) in
      print("####Error sending reply: error: \(error)")
    })
  }
}

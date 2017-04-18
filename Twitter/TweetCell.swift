//
//  TweetCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/13/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var timeLapseLabel: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var originalTweeterNameLabel: UILabel!
  @IBOutlet weak var originalTweeterHandleLabel: UILabel!
  @IBOutlet weak var originalTweeterImageView: UIImageView!
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      originalTweeterHandleLabel.sizeToFit()
      
      if (tweet?.favorited)! as Bool {
        favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
      
      if (tweet?.retweeted)! as Bool {
        retweetButton.setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
        
        // show the retweeters info
        
      } else {
        retweetButton.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
      }
      
      // User retweeting or original user tweet
      if tweet?.retweetedStatus != nil {
        nameLabel.isHidden = false
        retweetImageView.isHidden = false
        nameLabel.text = "\(tweet?.user?["screen_name"] as! String) retweeted"
        originalTweeterNameLabel.text = tweet?.retweetOriginalUser?["name"]! as! String?
        originalTweeterHandleLabel.text = "@\(tweet?.retweetOriginalUser?["screen_name"]! as! String)"
        
        let imagePath = tweet?.retweetOriginalUser?["profile_image_url_https"] as? String
        if imagePath != nil {
          let imageURL = URL(string: imagePath!)
          originalTweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
        } else {
          originalTweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
        }
        
      } else {
        originalTweeterNameLabel.text = tweet?.user?["name"]! as! String?
        originalTweeterHandleLabel.text = "@\(tweet?.user?["screen_name"]! as! String)"
        
        let imagePath = tweet?.user?["profile_image_url_https"] as? String
        if imagePath != nil {
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
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd/yy HH:mm"
      dateLabel.text = formatter.string(from: (tweet?.timestamp!)!)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

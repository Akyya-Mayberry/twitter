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
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var favButton: UIButton!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      nameLabel.text = tweet?.user?["name"] as? String
      handleLabel.text = "@ \(tweet?.user?["screen_name"] as! String)"
      
      let imagePath = tweet?.user?["profile_image_url_https"] as? String
      
      if imagePath != nil {
        let imageURL = URL(string: imagePath!)
        userImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
      } else {
        userImageView.image = #imageLiteral(resourceName: "twitterLogo")
      }
      
      userImageView.layer.cornerRadius = 10
      userImageView.clipsToBounds = true
      userImageView.layer.borderWidth = 3
      
      if (tweet?.favorited)! as Bool {
        favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
      
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
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

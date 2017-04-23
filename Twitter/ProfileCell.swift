//
//  ProfileCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/22/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var favoritesCountLabel: UILabel!
  @IBOutlet weak var retweetsCountLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var retweetsButton: UIButton!
  @IBOutlet weak var replyButton: UIButton!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      nameLabel.text = tweet?.user?["name"]! as? String
      handleLabel.text = tweet?.user?["screen_name"] as? String
      retweetsCountLabel.text = String(describing: (tweet?.retweetCount)!)
      favoritesCountLabel.text = String(describing: (tweet?.favouriteCount)!)
      
      if (tweet?.favorited)! as Bool {
        favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
      
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

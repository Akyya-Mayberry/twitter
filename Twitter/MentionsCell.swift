//
//  MentionsCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/23/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

@objc protocol MentionsCellDelegate {
  @objc func MentionsCell(mentionsCell: MentionsCell, didTap value: Bool)
}

class MentionsCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var replyToLabel: UILabel!
  @IBOutlet weak var retweetsCountLabel: UILabel!
  @IBOutlet weak var favoritesCountLabel: UILabel!
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var tweetText: UILabel!
  
  weak var delegate: MentionsCellDelegate?
  
  weak var tweet: Tweet? {
    didSet {
      nameLabel.text = tweet?.user?["name"] as! String?
      handleLabel.text = tweet?.user?["screen_name"] as! String?
      replyToLabel.text = tweet?.inReplyToScreenName
      tweetText.text = tweet?.text
      
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
    let profileTap = UITapGestureRecognizer(target: self, action: #selector(onImageTap(sender:)))
    userImageView.addGestureRecognizer(profileTap)
    userImageView.isUserInteractionEnabled = true
  }
  
  func onImageTap(sender: UIPanGestureRecognizer) {
    delegate?.MentionsCell(mentionsCell: self, didTap: true)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

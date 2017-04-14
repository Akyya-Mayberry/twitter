//
//  TweetCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/13/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var tweetText: UILabel!
  
  var tweet: Tweet? {
    didSet {
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
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

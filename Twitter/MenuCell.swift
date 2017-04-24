//
//  MenuCell.swift
//  Twitter
//
//  Created by hollywoodno on 4/21/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
  
  @IBOutlet weak var menuItemTitle: UILabel!
  @IBOutlet weak var menuItemImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

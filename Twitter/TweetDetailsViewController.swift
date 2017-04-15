//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/14/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var actionsStackView: UIStackView!
  @IBOutlet weak var tweeterImageView: UIImageView!
  
  public var tweet: Tweet?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      nameLabel.text = tweet?.user?["name"] as! String?
      handleLabel.text = "@ \(tweet?.user?["screen_name"] as! String)"
      
      let imagePath = tweet?.user?["profile_image_url_https"] as? String
      
      if imagePath != nil {
        let imageURL = URL(string: imagePath!)
        tweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
      } else {
        tweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
      }
      
      // Time lapse/date for Tweet Post
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      let timestamp = tweet?.timestamp
      let now = Date()
      let timePassed = now.timeIntervalSince(timestamp!)
        // Do any additional setup after loading the view.
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

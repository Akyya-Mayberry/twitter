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
  @IBOutlet weak var retweetsCountLabel: UILabel!
  @IBOutlet weak var favoritesCountLabel: UILabel!
  @IBOutlet weak var favButton: UIButton!
  
  public var indexPath: IndexPath?
  public var tweets: [Tweet]?
  public var tweet: Tweet?
  public var sender: TweetCell?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tweetText!.text = tweet?.text!
    tweetText!.sizeToFit()
    nameLabel.text = tweet?.user?["name"] as! String?
    handleLabel.text = "@ \(tweet?.user?["screen_name"] as! String)"
    retweetsCountLabel.text = String(describing: (tweet?.retweetCount)!)
    favoritesCountLabel.text = String(describing: (tweet?.favouriteCount)!)
    let imagePath = tweet?.user?["profile_image_url_https"] as? String
    
    if imagePath != nil {
      let imageURL = URL(string: imagePath!)
      tweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
    } else {
      tweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
    }
    
    if (tweet?.favorited)! as Bool {
      favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
    } else {
      favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm dd.MM.yy"
    
    dateLabel.text = formatter.string(from: (tweet?.timestamp!)!)
    //      dateLabel.text = String(describing: (tweet?.timestap)!)
    
    // Time lapse/date for Tweet Post
    //      let formatter = DateFormatter()
    //      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    //      let timestamp = tweet?.timestamp
    //      let now = Date()
    //      let timePassed = now.timeIntervalSince(timestamp!)
    // Do any additional setup after loading the view.
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func toggleFav(_ sender: Any) {
    // Reverses the state of a favorited value of a tweet.
    // Updates the tweet object and button to reflect the change.
    
    let sender = sender as! UIButton
    let favorited = tweet?.favorited!
    let id = tweet?.id!
    
    TwitterClient.sharedInstance?.updateFavoritedWith(id: id!, to: favorited!, success: { (response: Bool) in
      self.tweet?.favorited = response
      if response {
        sender.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        sender.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
    }, failure: { (error: Error) in
      print("Error updating favorited status: \(error.localizedDescription)")
    })
  }
  
  /* MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
   }
   */
  
}

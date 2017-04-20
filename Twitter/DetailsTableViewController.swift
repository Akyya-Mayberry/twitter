//
//  DetailsTableViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/20/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
  @IBOutlet weak var originalTweeterNameLabel: UILabel!
  @IBOutlet weak var originalTweeterHandleLabel: UILabel!
  @IBOutlet weak var originalTweeterImageView: UIImageView!


  
  @IBOutlet weak var tweetText: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var retweetsCountLabel: UILabel!
  @IBOutlet weak var favoritesCountLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favButton: UIButton!
  
//  @IBOutlet var tableView: UITableView!
  var indexPath: IndexPath?
  var tweets: [Tweet]?
  var tweet: Tweet?
  var sender: TweetCell?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
tableView.estimatedRowHeight = 120
      tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
      tweetText!.text = tweet?.text!
      tweetText!.sizeToFit()
      
      // User retweeting or original user
      if tweet?.retweetedStatus != nil {
        originalTweeterNameLabel.text = tweet?.retweetOriginalUser?["name"] as! String?
        originalTweeterHandleLabel.text = "@ \(tweet?.retweetOriginalUser?["screen_name"]! as! String)"
        let imagePath = tweet?.retweetOriginalUser?["profile_image_url_https"] as? String
        if imagePath != nil {
          let imageURL = URL(string: imagePath!)
          originalTweeterImageView.setImageWith(imageURL!, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
        } else {
          originalTweeterImageView.image = #imageLiteral(resourceName: "twitterLogo")
        }
      } else {
        originalTweeterNameLabel.text = tweet?.user?["name"] as! String?
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
      
      retweetsCountLabel.text = String(describing: (tweet?.retweetCount)!)
      favoritesCountLabel.text = String(describing: (tweet?.favouriteCount)!)
      
      if (tweet?.favorited)! as Bool {
        favButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
      } else {
        favButton.setImage(#imageLiteral(resourceName: "unfav"), for: .normal)
      }
      
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd/yy HH:mm"
      dateLabel.text = formatter.string(from: (tweet?.timestamp!)!)
      
      //Time lapse/date for Tweet Post
      //          let formatter = DateFormatter()
      //          formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      //          let timestamp = tweet?.timestamp
      //          let now = Date()
      //          let timePassed = now.timeIntervalSince(timestamp!)

    }

  @IBAction func onRetweet(_ sender: Any) {
    let sender = sender as! UIButton
    let id = tweet?.id!
    let retweeted = tweet?.retweeted!
    
    TwitterClient.sharedInstance?.updateRetweetStatus(id: id!, to: retweeted!, success: { (response: Bool) in
      self.tweet?.retweeted = response
      
      if response {
        (sender as AnyObject).setImage(#imageLiteral(resourceName: "retweeted"), for: .normal)
      } else {
        sender.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
      }
    }, failure: { (error: Error) in
      print("Issue retweeting, error: \(error)")
    })
  }
  
  @IBAction func onToggleFav(_ sender: Any) {
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
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navigationController = segue.destination as! UINavigationController
    let replyVC = navigationController.topViewController as! ReplyViewController
    replyVC.tweets = tweets!
    replyVC.tweet = tweet!
  }

}

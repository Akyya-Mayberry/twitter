//
//  TweetViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/14/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TweetViewController: UIViewController {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handlerLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var composeTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let currentUser = User.currentUser!
    nameLabel.text = currentUser.name
    handlerLabel.text = "@\(currentUser.screenname!)"
    
    if let imageURL = currentUser.profileUrl {
      userImageView.setImageWith(imageURL, placeholderImage: #imageLiteral(resourceName: "twitterLogo"))
    } else {
      userImageView.image = #imageLiteral(resourceName: "twitterLogo")
    }
    
    composeTextView.becomeFirstResponder()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Send Tweet Actions
  @IBAction func onCancel(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func onTweet(_ sender: Any) {
    TwitterClient.sharedInstance?.send(tweet: composeTextView.text!, success: { (response: Bool) in
      self.dismiss(animated: true)
    }, failure: { (error: Error) in
      print("########## HERE IS ERROR, \(error)")
    })
  }
  
}

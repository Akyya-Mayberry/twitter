//
//  LoginViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/11/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
  @IBOutlet weak var logoImageView: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    logoImageView.layer.cornerRadius = 10
    logoImageView.clipsToBounds = true
//    logoImageView.layer.borderWidth = 3
//    logoImageView.layer.borderColor = UIColor.white.cgColor
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogin(_ sender: Any) {
    
    // Loging using twitter client
    TwitterClient.sharedInstance?.login(success: {
      // Segue to navigation controller of tweets view controller
      self.performSegue(withIdentifier: "loginSegue", sender: self)
    }, failure: { (error: Error) in
      print("Error: \(error.localizedDescription)")
    })
  }
}

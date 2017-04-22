//
//  ContainerViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/22/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var contentViewLeftMargin: NSLayoutConstraint!
  
  // Start of pan gesture
  var originalLeftMargin: CGFloat!
  
  // Set up menu view controller, it will control access to container views
  var menuViewController: MenuViewController! {
    didSet {
      view.layoutIfNeeded()
      menuView.addSubview(menuViewController.view)
    }
  }
  
  // Set's the controller that will manage the content view
  var contentViewController: UIViewController! {
    didSet(oldContentViewController) {
      // Remove any previous view controller
      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }
      
      view.layoutIfNeeded()
      
      // Prep new view controller
      contentViewController.willMove(toParentViewController: self)
      contentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)
      // Close the menu
      UIView.animate(withDuration: 0.3) {
        self.contentViewLeftMargin.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up pan gesture on container/content view
    let pan = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(sender:)))
    contentView.addGestureRecognizer(pan)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // Displays menu when user pans on content
  func onPanGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    let velocity = sender.velocity(in: view)
    
    if sender.state == .began {
      // Store original left margin
      originalLeftMargin = contentViewLeftMargin.constant
    } else if sender.state == .changed {
      // Move content view origin position by modifying it's left margin to allow view to move with user pan
      contentViewLeftMargin.constant = originalLeftMargin + translation.x
    } else if sender.state == .ended {
      // Open side menu
      UIView.animate(withDuration: 0.09, animations: {
        if velocity.x > 0 {
          // Can completely remove content view by pushing the left margin past
          // the main view's width, or subtract from that value to allow portion of
          // content view to remain on screen
          self.contentViewLeftMargin.constant = self.view.frame.width - 60
        } else {
          // Close side menu
          
          // Set the content view to grow to fullsize of screen
          self.contentViewLeftMargin.constant = 0
        }
        self.view.layoutIfNeeded()
      })
    }
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

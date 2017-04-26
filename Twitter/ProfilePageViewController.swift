//
//  ProfilePageViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/23/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  // Set up the list of view controllers
  lazy var profileHeaderViewControllers: [UIViewController] = {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return [storyboard.instantiateViewController(withIdentifier: "BasicProfileViewController") as! BasicProfileViewController,
            storyboard.instantiateViewController(withIdentifier: "ProfileDescriptionViewController") as! ProfileDescriptionViewController
    ]
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Required for gesturing on pages
    self.dataSource = self
    self.delegate = self
    
    // Set the default page item in header section
    if let basicProfile = profileHeaderViewControllers.first {
      setViewControllers([basicProfile as! BasicProfileViewController], direction: .forward, animated: true, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Getting the previous view controller
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    // I am given the current view controller and must determine what came before it
    
    // Attempt to get current view controller if one exists,
    // by retrieving where in the array of view controllers is the current view controller (it's index)
    guard let viewControllerIndex = profileHeaderViewControllers.index(of: viewController) else {
      return nil
    }
    
    // Based on the current view controller index, attempt to get
    // the index before it, this will respresent the previous controller
    let previousIndex = viewControllerIndex - 1
    
    // If there is no view previous view controller,
    // current controller is the first, so we cycle to the last view controller
    guard previousIndex >= 0 else {
      return profileHeaderViewControllers.last
    }
    
    // Extra precaution
    guard profileHeaderViewControllers.count > previousIndex else {
      return nil
    }
    
    return profileHeaderViewControllers[previousIndex]
  }
  
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    // I am given the current view controller and must determine what comes after it.
    
    // Attempt to get current view controller if one exists,
    // by retrieving where in the array of view controllers is the current view controller (it's index)
    guard let viewControllerIndex = profileHeaderViewControllers.index(of: viewController) else {
      return nil
    }
    
    // Based on the current view controller index, attempt to get
    // the index after it, this will respresent the next controller to display
    let nextIndex = viewControllerIndex + 1
    
    // If there is no view next view controller,
    // current controller is the last, so we cycle to the first view controller
    guard nextIndex < profileHeaderViewControllers.count else {
      return profileHeaderViewControllers.first
    }
    
    // Extra precaution
    guard profileHeaderViewControllers.count > nextIndex else {
      return nil
    }
    return profileHeaderViewControllers[nextIndex]
  }
  
  
  // A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
  // Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return profileHeaderViewControllers.count
  }
  
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    
    guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = profileHeaderViewControllers.index(of: firstViewController) else {
      return 0
    }
    
    return firstViewControllerIndex
//    return 0
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

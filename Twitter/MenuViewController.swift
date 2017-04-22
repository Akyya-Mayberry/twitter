//
//  MenuViewController.swift
//  Twitter
//
//  Created by hollywoodno on 4/20/17.
//  Copyright © 2017 hollywoodno. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  private var profileViewController: UIViewController!
  private var tweetsViewController: UIViewController!
  private var mentionsViewController: UIViewController!
  
  var viewControllers: [UIViewController] = []
  let menuItemsTitles = ["Profile", "Home Timeline", "Mentions"]
  var containerViewController: ContainerViewController!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.dataSource = self
      tableView.delegate = self
      
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      profileViewController = storyboard.instantiateViewController(withIdentifier: "profileNavigationController")
       tweetsViewController = storyboard.instantiateViewController(withIdentifier: "tweetsNavigationController")
      mentionsViewController = storyboard.instantiateViewController(withIdentifier: "mentionsNavigationController")
      viewControllers.append(contentsOf: [profileViewController,  tweetsViewController, mentionsViewController])
      
      // Start container view controller to display current users home timeline
      containerViewController.contentViewController = tweetsViewController
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
    cell.menuItemTitle.text = menuItemsTitles[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    containerViewController.contentViewController = viewControllers[indexPath.row]
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

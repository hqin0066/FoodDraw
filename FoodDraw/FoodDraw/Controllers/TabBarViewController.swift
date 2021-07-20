//
//  TabBarViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let vc1 = HomeViewController()
    let vc2 = ListViewController()
    
    vc2.navigationItem.largeTitleDisplayMode = .never
    
    vc1.title = "Home"
    vc2.title = "List"
    
    let nav1 = UINavigationController(rootViewController: vc1)
    let nav2 = UINavigationController(rootViewController: vc2)
    
    nav1.isNavigationBarHidden = true
    nav2.navigationBar.prefersLargeTitles = false
    
    nav1.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "map"), tag: 0)
    nav2.tabBarItem = UITabBarItem(title: "LIST", image: UIImage(systemName: "list.dash"), tag: 1)
    
    view.tintColor = UIColor(named: "Gold")!
    
    setViewControllers([nav1, nav2], animated: false)
    
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.backgroundEffect = UIBlurEffect(style: .light)
      tabBar.scrollEdgeAppearance = appearance
    }
  }
}

//
//  MockTabBarController.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 10/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class MockTabBarController: UITabBarController {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.viewControllers = [initialTabBar, finalTabBar]
  }

  lazy public var initialTabBar: MockItemViewController = {

    let initialTabBar = MockItemViewController()

    initialTabBar.tabBarItem = tabBarItem

    return initialTabBar
  }()

  lazy public var finalTabBar: MockTestViewController = {

    let finalTabBar = MockTestViewController()

    finalTabBar.tabBarItem = tabBarItem

    return finalTabBar
  }()

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

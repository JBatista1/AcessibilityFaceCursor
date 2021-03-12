//
//  MockNavigationController.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 10/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.viewControllers = [initialNavBar, finalNavBar]
  }

  lazy public var initialNavBar: MockItemViewController = {

    let initialTabBar = MockItemViewController()
    
    return initialTabBar
  }()

  lazy public var finalNavBar: MockTestViewController = {

    let finalTabBar = MockTestViewController()

    return finalTabBar
  }()

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

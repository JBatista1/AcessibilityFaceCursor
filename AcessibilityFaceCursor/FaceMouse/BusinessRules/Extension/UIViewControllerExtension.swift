//
//  UIViewControllerExtension.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 13/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public extension UIViewController  {

  func getTabBar() -> UITabBar? {
    guard let tabBar = tabBarController?.tabBar else {
      return nil
    }
    return tabBar
  }

  func getNavigationBar() -> UINavigationBar? {
    guard let navBar = navigationController?.navigationBar else {
      return nil
    }
    return navBar
  }

  func getNavigationBackButton() -> UIView? {
    guard let navBar = navigationController?.navigationBar else {
      return nil
    }

    if navBar.subviews.count >= 2 {
      let views = navBar.subviews
      for view in views {
        if view.isKind(of: NSClassFromString("_UINavigationBarContentView")!) && view.subviews.count >= 1 {
          return view.subviews.first
        }
      }
    }
    return nil
  }

  func createViewsActionInTabBar(withSelector selector: Selector) -> [ViewAction] {
    if let tabBar = self.getTabBar() {
      return [ViewAction(view: tabBar, selector: selector)]
    }
    return []
  }

  func createViewsActionBackNavigationBar(withSelector selector: Selector) -> [ViewAction] {
    if let navBar = self.getNavigationBackButton() {
      return [ViewAction(view: navBar, selector: selector)]
    }
    return []
  }

  func getViewActionNavigationAndTabBar(withSelectorTabBar tabSelector: Selector, andSelectorNavBar navSelectorT: Selector) -> [ViewAction] {
    var newViewActions = [ViewAction]()
    newViewActions.append(contentsOf: self.createViewsActionInTabBar(withSelector: tabSelector))
    newViewActions.append(contentsOf: self.createViewsActionBackNavigationBar(withSelector: navSelectorT))
    return newViewActions
  }
}

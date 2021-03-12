//
//  ManagesSpecialCases.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 26/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class ManagesSpecialCases {

  private var position = Position(views: [])
  private let indexPathError = ValuesConstants.indexPathError
  internal init() {}

  func getIndexPathTheTable(InView view: UIView, andPoint pointView: CGPoint) -> IndexPath {
    guard let tableView = view as? UITableView else {return indexPathError}
    let views = tableView.getCell()
    let index = position.getViewSelectedBased(thePoint: pointView, InTableViewCells: views)
    if let safeIndex = index, let indexPath = views[safeIndex].accessibilityElements?.first as? IndexPath {
      return indexPath
    }
    return indexPathError
  }

  func getIndexPathTheUICollectionView(InView view: UIView, andPoint pointView: CGPoint) -> IndexPath {
    guard let collectionView = view as? UICollectionView else { return indexPathError }
    let views = collectionView.getCell()
    let index = position.getViewSelectedBased(thePoint: pointView, InTableViewCells: views)
    if let safeIndex = index, let indexPath = views[safeIndex].accessibilityElements?.first as? IndexPath {
      return indexPath
    }
    return indexPathError
  }

  func inserTabBarViews(inViewsAction viewsAction: [ViewAction]) -> [ViewAction] {
    var newViewsActions = viewsAction
    var index = 0
    for viewAction in viewsAction {
      if let tabBar = viewAction.view as? UITabBar {
        newViewsActions.remove(at: index)
        newViewsActions.append(contentsOf: getTabBarViews(inTabBar: tabBar, andSelector: viewAction.selector))
      }
      index += 1
    }
    return newViewsActions
  }

  func insertAccessibilityIdentifier(inViewsAction viewsAction: [ViewAction]) -> [ViewAction] {
    for viewAction in viewsAction {
      switch viewAction.view {
      case is UIButton:
        viewAction.view.accessibilityIdentifier = AccessibilityUIType.uiButton.identifier
      case is UIImageView:
        viewAction.view.accessibilityIdentifier = AccessibilityUIType.uiImageView.identifier
      case is UITableView:
        viewAction.view.accessibilityIdentifier = AccessibilityUIType.uiTableView.identifier
      case is UICollectionView:
        viewAction.view.accessibilityIdentifier = AccessibilityUIType.uiCollectionView.identifier
      default:
        break
      }
    }
    return viewsAction
  }

  private func getTabBarViews(inTabBar tabBar: UITabBar, andSelector selector: Selector) -> [ViewAction] {
    var viewsTabbar = [ViewAction]()
    var index = 0
    for view in tabBar.subviews {
      if view.isKind(of: NSClassFromString("UITabBarButton")!) {
        view.accessibilityIdentifier = "\(index)"
        viewsTabbar.append(ViewAction(view: view, selector: selector))
        index += 1
      }
    }
    return viewsTabbar
  }
}

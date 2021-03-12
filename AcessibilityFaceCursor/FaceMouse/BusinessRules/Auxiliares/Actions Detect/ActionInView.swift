//
//  ActionInView.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 07/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class ActionInView: NSObject {

  private var typeStartAction: TypeStartAction
  private var target: UIViewController

  private var pointView: CGPoint = .zero
  private var manageCase = ManagesSpecialCases()
  private var timer = TimerControl()
  private (set) var position: PositionProtocol?
  private (set) var isCooldown = false
  private (set) var viewsAction: [ViewAction] = []

  required init(typeStartAction: TypeStartAction = .tongue, target: UIViewController, position: PositionProtocol? = nil) {
    self.typeStartAction = typeStartAction
    self.target = target
    super.init()
    timer.delegate = self
    self.position = position
  }

  // MARK: - Private Method

  private func calledSelector(inViewAction viewAction: ViewAction) {
    if let identifier = viewAction.view.accessibilityIdentifier {
      calledSpecialTarget(withIndentifier: identifier, inViewAction: viewAction)
    } else {
      self.target.perform(viewAction.selector)
    }
  }

  private func calledSpecialTarget(withIndentifier identifier: String, inViewAction viewAction: ViewAction) {
    switch identifier {
    case AccessibilityUIType.uiButton.identifier,
         AccessibilityUIType.uiImageView.identifier,
         AccessibilityUIType.uiTabBar.identifier:
      self.target.perform(viewAction.selector, with: identifier)

    case AccessibilityUIType.uiTableView.identifier:
      let indexPath = manageCase.getIndexPathTheTable(InView: viewAction.view, andPoint: pointView)
      self.target.perform(viewAction.selector, with: indexPath)

    case AccessibilityUIType.uiCollectionView.identifier:
      let indexPath = manageCase.getIndexPathTheUICollectionView(InView: viewAction.view, andPoint: pointView)
      self.target.perform(viewAction.selector, with: indexPath)

    default:
      self.target.perform(viewAction.selector, with: identifier)
    }
  }

  private func verify(theEyeClose eyeClose: CGFloat, andEyeOpen eyeOpen: CGFloat) -> Bool {
    return eyeClose >= ValuesConstants.closeEye && eyeOpen <= ValuesConstants.openEye
  }

  private func createPosition(withViews views: [UIView]) {
    if position != nil {
      position?.set(theViews: views)
    }else {
      position = Position(views: views)
    }
  }
}

// MARK: - Extension

extension ActionInView: ActionProtocol {

  func verifyAction(withValueEyeRight eyeRight: CGFloat, theEyeLeft eyeLeft: CGFloat, andTongueValue tongue: CGFloat) -> Bool {
    switch typeStartAction {
    case .eyeLeft:
      return verify(theEyeClose: eyeLeft, andEyeOpen: eyeRight)
    case .eyeRight:
      return verify(theEyeClose: eyeRight, andEyeOpen: eyeLeft)
    case .tongue:
      return tongue >= ValuesConstants.tongue
    case .voice:
      return false
    }
  }

  func getViewForAction(withPoint point: CGPoint) {
    pointView = point
    if let index = position?.getViewSelectedBased(thePoint: point) {
      let viewAction = viewsAction[index]
      DispatchQueue.main.async {
        if !self.isCooldown {
          self.timer.startTimer(withTimerSeconds: ValuesConstants.cooldown)
          self.isCooldown = true
          self.calledSelector(inViewAction: viewAction)
        }
      }
    }
  }

  func setTypeStartAction(withType type: TypeStartAction) {
    self.typeStartAction = type
  }

  func set(viewsAction: [ViewAction]) {
    var views = [UIView]()

    var newViewsAction = manageCase.inserTabBarViews(inViewsAction: viewsAction)
    newViewsAction = manageCase.insertAccessibilityIdentifier(inViewsAction: newViewsAction)

    for viewAction in newViewsAction {
      views.append(viewAction.view)
    }

    createPosition(withViews: views)
    self.viewsAction = newViewsAction
  }

  func getType() -> TypeStartAction {
    return typeStartAction
  }
}

extension ActionInView: TimerActionResponseProtocol {
  func finishTimer() {
    isCooldown = false
  }
}

//
//  MockPosition.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 07/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Foundation
import UIKit
@testable import AcessibilityFaceMouse

class MockPosition: PositionProtocol {

  private var views: [UIView]
  private var position: Position

  init(views: [UIView]) {
    self.views = views
    position = Position(views: views)
  }

  func getViewSelectedBased(thePoint point: CGPoint) -> Int? {
    var index = 0
    for view in views  {
      if position.verify(withPoint: point, insideInFrame: view.frame) {
        return index
      }
      index += 1
    }
    return nil
  }

  func set(theViews views: [UIView]) {
    self.views = views
    position = Position(views: views)
  }

  func getViewSelectedBased(thePoint point: CGPoint, InTableViewCells tableViewCells: [UIView]) -> Int? {
    return 1
  }

  func getViewSelectedBased(thePoint point: CGPoint, InCollectionViewCells collectionViewCells: [UIView]) -> Int? {
    return 1
  }

  func verify(withPoint point: CGPoint, insideInFrame frame: CGRect) -> Bool {
    return true
  }
}

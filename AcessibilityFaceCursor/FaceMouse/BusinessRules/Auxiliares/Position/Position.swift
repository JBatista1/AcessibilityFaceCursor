//
//  Position.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 10/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class Position: PositionProtocol {
  private (set)var views: [UIView]
  private var absolutePosition: [CGRect] = []
  private var absolutePositionTable: [CGRect] = []

  init(views: [UIView]) {
    self.views = views
    absolutePosition = getAbsolutePosition(inViews: views)
  }

  func set(theViews views: [UIView]) {
    self.views = views
    absolutePosition = getAbsolutePosition(inViews: views)
  }

  func getViewSelectedBased(thePoint point: CGPoint) -> Int? {
    for index in 0..<views.count {
      if verify(withPoint: point, insideInFrame: absolutePosition[index]) {
        return index
      }
    }
    return nil
  }

  func getViewSelectedBased(thePoint point: CGPoint, InTableViewCells tableViewCells: [UIView]) -> Int? {
    absolutePositionTable = getAbsolutePosition(inViews: tableViewCells)
    for index in 0..<tableViewCells.count {
      if verify(withPoint: point, insideInFrame: absolutePositionTable[index]) {
        return index
      }
    }
    return nil
  }

  func getViewSelectedBased(thePoint point: CGPoint, InCollectionViewCells collectionViewCells: [UIView]) -> Int? {
    absolutePositionTable = getAbsolutePosition(inViews: collectionViewCells)
    for index in 0..<collectionViewCells.count {
      if verify(withPoint: point, insideInFrame: absolutePositionTable[index]) {
        return index
      }
    }
    return nil
  }

  func verify(withPoint point: CGPoint, insideInFrame frame: CGRect) -> Bool {
    if point.x >= frame.minX && point.x < frame.maxX {
      if point.y >= frame.minY && point.y < frame.maxY {
        return true
      }
    }
    return false
  }

  private func getAbsolutePosition(inViews views: [UIView]) -> [CGRect] {
    var absolutePosition = [CGRect]()
    for view in views {
      absolutePosition.append(view.absoluteValueToFrame())
    }
    return absolutePosition
  }
  
}
